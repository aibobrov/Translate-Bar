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
}
