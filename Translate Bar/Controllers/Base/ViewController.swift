//
//  ViewController.swift
//  Translate Bar
//
//  Created by Artem Bobrov on 03.07.2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
	override func viewDidAppear() {
		super.viewDidAppear()
		NSApplication.shared.activate(ignoringOtherApps: true)
	}

	public func removeFromParentWindow() {
		let appDelegate = NSApplication.shared.delegate as! AppDelegate // swiftlint:disable:this force_cast
		let popoverWindow = self.view.window!
		guard let parentWindow = popoverWindow.parent else { return }
		appDelegate.parentWindow = parentWindow
		appDelegate.parentWindow?.removeChildWindow(popoverWindow)
	}

	public func addToParentWindow() {
		let appDelegate = NSApplication.shared.delegate as! AppDelegate // swiftlint:disable:this force_cast
		let popoverWindow = self.view.window!
		appDelegate.parentWindow?.addChildWindow(popoverWindow, ordered: .above)
	}
}
