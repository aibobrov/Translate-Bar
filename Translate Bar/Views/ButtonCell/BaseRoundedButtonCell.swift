//
//  BaseRoundedButtonCell.swift
//  Translate Bar
//
//  Created by Artem Bobrov on 16.06.2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa

protocol CustomButtonCellProtocol where Self: NSButtonCell {
	func draw(withFrame cellFrame: NSRect, in controlView: NSView)
	func path(for rect: NSRect) -> NSBezierPath
	func draw(text: String, in rect: NSRect)
}

class CustomRoundedButtonCell: NSButtonCell, CustomButtonCellProtocol {
	var strokeColor: NSColor = .lightGray
	var tintColor: NSColor = .gray
	var mainColor: NSColor = NSColor(red: 250 / 255, green: 250 / 255, blue: 250 / 255, alpha: 1)
	var cornerRadius: CGFloat = 5

	override func draw(withFrame cellFrame: NSRect, in controlView: NSView) {
		let bezierPath = path(for: cellFrame)
		backgroundColor().setFill()
		bezierPath.fill()

		if (self.title ?? "").count > 0 {
			draw(text: self.title, in: cellFrame)
		} else if let image = self.image {
			let filledColor: NSColor = self.state == .on ? .white : self.tintColor
			let imageRect = self.imageRect(forBounds: cellFrame).scaledToFit(bounds: cellFrame, with: 5)
			image.tinted(by: filledColor).draw(in: imageRect)
		}

	}

	func path(for rect: NSRect) -> NSBezierPath {
		return NSBezierPath(rect: rect)
	}

	func draw(text: String, in rect: NSRect) {
		guard let font = self.font else {
			Log.warning("No font for button")
			return
		}

		let textColor: NSColor = self.state == .on ? .white : tintColor

		let style = NSMutableParagraphStyle()
		style.alignment = .center

		let attributes = [NSAttributedStringKey.font: font,
						  NSAttributedStringKey.foregroundColor: textColor,
						  NSAttributedStringKey.paragraphStyle: style]


		let attributedString = NSAttributedString(string: text, attributes: attributes)

		let textFrame = NSRect(x: rect.origin.x,
							   y: -3.5,
							   width: rect.width,
							   height: 22)

		attributedString.draw(in: textFrame)
	}

	private func backgroundColor() -> NSColor {
		return self.state == .on ? tintColor : mainColor
	}
}
