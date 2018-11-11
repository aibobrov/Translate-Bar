//
//  AppDelegate.swift
//  TranslateBar
//
//  Created by Artem Bobrov on 20/10/2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa
import Magnet

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    let statusItem: NSStatusItem = {
        let item = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = item.button {
            button.image = Asset.language.image
            button.alternateImage = Asset.languageFilled.image
            button.action = #selector(togglePopover(_:))
            button.appearsDisabled = false
        }
        return item
    }()

    let popover: NSPopover = {
        let popover = NSPopover()
        popover.animates = true
        popover.behavior = .transient
        popover.appearance = NSAppearance(named: .vibrantLight)
        return popover
    }()

    var toggleAppHotKey: HotKey?
    var coordinator: AppCoordinator!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        coordinator = PopoverCoordinator(popover: popover)
        coordinator.start()
        applyApplicationSettings()
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

    public func setupToggleShortcut(with combo: KeyCombo?) {
        toggleAppHotKey?.unregister()
        if let combo = combo {
            toggleAppHotKey = HotKey(identifier: "ToggleAppHotKey", keyCombo: combo, target: self, action: #selector(togglePopoverFromMenuBar), actionQueue: .main)
            toggleAppHotKey!.register()
        }
    }

    private func applyApplicationSettings() {
        let settings = Settings.shared
        NSApplication.shared.setActivationPolicy(settings.isShowIconInDock ? .regular : .accessory)
        if let keyCombo = settings.toggleAppShortcut {
            setupToggleShortcut(with: keyCombo)
        }
    }

    @objc func togglePopoverFromMenuBar() {
        if let button = statusItem.button {
            togglePopover(button)
        }
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "TranslateBar")
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving and Undo support

    @IBAction func saveAction(_ sender: AnyObject?) {
        // Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
        let context = persistentContainer.viewContext

        if !context.commitEditing() {
            NSLog("\(NSStringFromClass(type(of: self))) unable to commit editing before saving")
        }
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Customize this code block to include application-specific recovery steps.
                let nserror = error as NSError
                NSApplication.shared.presentError(nserror)
            }
        }
    }

    func windowWillReturnUndoManager(window: NSWindow) -> UndoManager? {
        // Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
        return persistentContainer.viewContext.undoManager
    }

    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        // Save changes in the application's managed object context before the application terminates.
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

            // Customize this code block to include application-specific recovery steps.
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
        // If we got here, it is time to quit.
        return .terminateNow
    }
}
