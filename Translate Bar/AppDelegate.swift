//
//  AppDelegate.swift
//  Translate Bar
//
//  Created by Artem Bobrov on 09.06.2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa
import RxSwift
import RxCocoa
import SwiftyBeaver
import Moya
import EVReflection

let Log = SwiftyBeaver.self // swiftlint:disable:this variable_name 

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
	private let (mainImage, alternateImage) = (#imageLiteral(resourceName: "language"), #imageLiteral(resourceName: "language_filled"))
	private let disposeBag = DisposeBag()

	let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

	let popover: NSPopover = {
		let popover = NSPopover()
		popover.animates = true
		popover.behavior = .transient
		popover.appearance = NSAppearance(named: .vibrantLight)
		return popover
	}()

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		Log.addDestination(ConsoleDestination())

		if let button = statusItem.button {
			button.image = mainImage
			button.alternateImage = alternateImage
			button.action = #selector(togglePopover(_:))
		}

		popover.contentViewController = NSStoryboard.instantiateController(from: "Main", withIdentifier: "MainVCID")

		popover.rx.observe(Bool.self, #keyPath(NSPopover.isShown))
			.map({ $0 ?? false })
			.subscribe { [unowned self] event in

				self.statusItem.button?.image = event.element! ? self.alternateImage : self.mainImage
			}
			.disposed(by: disposeBag)
	}

	func applicationWillTerminate(_ aNotification: Notification) {
	}

	func showPopover(_ sender: NSView) {
		popover.show(relativeTo: sender.bounds, of: sender, preferredEdge: .maxY)
	}

	func closePopover(_ sender: NSView) {
		popover.performClose(sender)
	}

	@objc func togglePopover(_ sender: NSView) {
		if popover.isShown {
			closePopover(sender)
		} else {
			showPopover(sender)
		}
	}

	// MARK: - Core Data stack
	lazy var persistentContainer: NSPersistentContainer = {
	    let container = NSPersistentContainer(name: "Translate_Bar")
	    container.loadPersistentStores(completionHandler: { (_, error) in
	        if let error = error {
	            fatalError("Unresolved error \(error)")
	        }
	    })
	    return container
	}()

	// MARK: - Core Data Saving and Undo support

	@IBAction func saveAction(_ sender: AnyObject?) {
	    let context = persistentContainer.viewContext

	    if !context.commitEditing() {
	        NSLog("\(NSStringFromClass(type(of: self))) unable to commit editing before saving")
	    }
	    if context.hasChanges {
	        do {
	            try context.save()
	        } catch {

	            let nserror = error as NSError
	            NSApplication.shared.presentError(nserror)
	        }
	    }
	}

	func windowWillReturnUndoManager(window: NSWindow) -> UndoManager? {
	    return persistentContainer.viewContext.undoManager
	}

	func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
	    let context = persistentContainer.viewContext

	    if !context.commitEditing() {
	        NSLog("\(NSStringFromClass(type(of: self))) unable to commit editing to terminate")
	        return .terminateCancel
	    }

	    if !context.hasChanges {
	        return .terminateNow
	    }

	    do {
	        try context.save()
	    } catch {
	        let nserror = error as NSError

	        let result = sender.presentError(nserror)
	        if result {
	            return .terminateCancel
	        }

	        let question = NSLocalizedString("Could not save changes while quitting. Quit anyway?", comment: "Quit without saves error question message")
	        let info = NSLocalizedString("Quitting now will lose any changes you have made since the last successful save", comment: "Quit without saves error question info")
	        let quitButton = NSLocalizedString("Quit anyway", comment: "Quit anyway button title")
	        let cancelButton = NSLocalizedString("Cancel", comment: "Cancel button title")
	        let alert = NSAlert()
	        alert.messageText = question
	        alert.informativeText = info
	        alert.addButton(withTitle: quitButton)
	        alert.addButton(withTitle: cancelButton)

	        let answer = alert.runModal()
	        if answer == .alertSecondButtonReturn {
	            return .terminateCancel
	        }
	    }

	    return .terminateNow
	}
}
