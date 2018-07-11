//
//  LanguageCollectionViewItem.swift
//  Translate Bar
//
//  Created by Artem Bobrov on 30.06.2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa

class LanguageCollectionViewItem: NSCollectionViewItem, Highlightable {
	var isHighlighted: Bool = false {
		didSet {
			if isHighlighted {
				highlight()
			} else {
				unhighlight()
			}
		}
	}

	override func mouseEntered(with event: NSEvent) {
		super.mouseEntered(with: event)
		isHighlighted = true
	}

	override func mouseExited(with event: NSEvent) {
		super.mouseEntered(with: event)
		isHighlighted = false
	}

	func highlight() {
		self.view.layer?.borderWidth = 0.5
		self.view.layer?.borderColor = NSColor.alternateSelectedControlColor.cgColor
		self.view.layer?.backgroundColor = NSColor.controlColor.cgColor
	}

	func unhighlight() {
		self.view.layer?.borderWidth = 0
		self.view.layer?.backgroundColor = NSColor.clear.cgColor
	}

	lazy var mouseTrackingArea = NSTrackingArea(rect: view.bounds, options: [.activeInActiveApp, .mouseEnteredAndExited], owner: self, userInfo: nil)

	override func viewDidLoad() {
		super.viewDidLoad()
		view.addTrackingArea(mouseTrackingArea)
	}

	override func viewDidLayout() {
		super.viewDidLayout()
		view.removeTrackingArea(mouseTrackingArea)
		mouseTrackingArea = NSTrackingArea(rect: view.bounds, options: [.activeInActiveApp, .mouseEnteredAndExited], owner: self, userInfo: nil)
		view.addTrackingArea(mouseTrackingArea)
	}

}
