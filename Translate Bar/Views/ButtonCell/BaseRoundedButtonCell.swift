//
//  BaseRoundedButtonCell.swift
//  Translate Bar
//
//  Created by Artem Bobrov on 16.06.2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa

protocol CustomButtonCell where Self: NSButtonCell {
	func draw(withFrame cellFrame: NSRect, in controlView: NSView)
	func path(for rect: NSRect) -> NSBezierPath
}

class CustomRoundedButtonCell: NSButtonCell, CustomButtonCell {
	var strokeColor: NSColor = .lightGray
	var tintColor: NSColor = .gray
	var mainColor: NSColor = NSColor(red: 250 / 255, green: 250 / 255, blue: 250 / 255, alpha: 1)
	var cornerRadius: CGFloat = 5

	override func draw(withFrame cellFrame: NSRect, in controlView: NSView) {
		let bezierPath = path(for: cellFrame)
		backgroundColor().setFill()
		bezierPath.fill()

		let text = self.textForSegment()

		let textFrame = NSRect(x: cellFrame.origin.x,
							   y: -3.5,
							   width: cellFrame.width,
							   height: 22)
		text.draw(in: textFrame)
	}

	func path(for rect: NSRect) -> NSBezierPath {
		return NSBezierPath(rect: rect)
	}
	
	private func backgroundColor() -> NSColor {
		return self.state == .on ? tintColor : mainColor
	}

	private func textForSegment() -> NSAttributedString {
		let font = NSFont(name: "OpenSans-Regular", size: 15)!

		let textColor: NSColor = self.state == .on ? .white : tintColor

		let style = NSMutableParagraphStyle()
		style.alignment = .center

		let attributes = [NSAttributedStringKey.font: font,
						  NSAttributedStringKey.foregroundColor: textColor,
						  NSAttributedStringKey.paragraphStyle: style]


		let text = NSAttributedString(string: self.title ?? "", attributes: attributes)
		return text
	}
}
