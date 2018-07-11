//
//  View.swift
//  Translate Bar
//
//  Created by Artem Bobrov on 14.06.2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa

@IBDesignable
class View: NSView {

	@IBInspectable
	var backgroundColor: NSColor = .clear {
		didSet {
			self.layer?.backgroundColor = backgroundColor.cgColor
		}
	}

	@IBInspectable
	var cornerRadius: CGFloat = 0 {
		didSet {
			self.layer?.cornerRadius = cornerRadius
		}
	}

	override init(frame frameRect: NSRect) {
		super.init(frame: frameRect)
		setup()
	}

	required init?(coder decoder: NSCoder) {
		super.init(coder: decoder)
		setup()
	}

	private func setup() {
		self.wantsLayer = true
	}

	override func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()
		self.layer?.cornerRadius = cornerRadius
		self.layer?.backgroundColor = backgroundColor.cgColor
	}

}
