//
//  BaseRoundedSegmentedCell.swift
//  Translate Bar
//
//  Created by Artem Bobrov on 16.06.2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa

protocol CustomSegmentedCell where Self: NSSegmentedCell {
	func draw(withFrame cellFrame: NSRect, in controlView: NSView)

	func drawSegmentItem(_ segment: Int, in frame: NSRect, with controlView: NSView)
}

class CustomRoundedSegmentCell: NSSegmentedCell, CustomSegmentedCell {
	var strokeColor: NSColor = .lightGray
	var tintColor: NSColor = .gray
	var mainColor: NSColor = .white
	var cornerRadius: CGFloat = 7

	override func draw(withFrame cellFrame: NSRect, in controlView: NSView) {
		let cellWidth = cellFrame.width / CGFloat(self.segmentCount)
		for index in 0 ..< self.segmentCount {
			let x = cellWidth * CGFloat(index)
			let rect = NSRect(x: x, y: 0, width: cellWidth, height: cellFrame.height)
			drawSegmentItem(index, in: rect, with: controlView)
		}
	}

	func drawSegmentItem(_ segment: Int, in frame: NSRect, with controlView: NSView) {
		let bezierPath: NSBezierPath = path(for: segment, in: frame)
		backgroundColor(for: segment).setFill()
		bezierPath.fill()

		let text = self.textForSegment(segment)

		let textFrame = NSRect(x: frame.origin.x,
							   y: -2,
							   width: frame.width,
							   height: 22)
		text.draw(in: textFrame)
	}

	private func backgroundColor(for segment: Int) -> NSColor {
		return selectedSegment == segment ? tintColor : mainColor
	}

	func path(for segment: Int, in rect: NSRect) -> NSBezierPath {
		return NSBezierPath(rect: rect)
	}

	private func textForSegment(_ segment: Int) -> NSAttributedString {
		let font = NSFont(name: "OpenSans-Regular", size: 13)!

		let textColor: NSColor
		if self.selectedSegment == segment {
			textColor = .white
		} else {
			textColor = self.tintColor
		}

		let style = NSMutableParagraphStyle()
		style.alignment = .center

		let attributes = [NSAttributedStringKey.font: font,
						  NSAttributedStringKey.foregroundColor: textColor,
						  NSAttributedStringKey.paragraphStyle: style]

		let text = NSAttributedString(string: self.label(forSegment: segment) ?? "", attributes: attributes)
		return text
	}

}
