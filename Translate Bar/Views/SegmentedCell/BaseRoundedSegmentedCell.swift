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
	var mainColor: NSColor = NSColor(red: 250 / 255, green: 250 / 255, blue: 250 / 255, alpha: 1)
	var cornerRadius: CGFloat = 5

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

		var textFrame = NSRect(x: frame.origin.x,
							   y: -3.5,
							   width: frame.width,
							   height: 22)
        textFrame.center = frame.center
        draw(for: segment, in: textFrame)
	}

	private func backgroundColor(for segment: Int) -> NSColor {
		return selectedSegment == segment ? tintColor : mainColor
	}

	func path(for segment: Int, in rect: NSRect) -> NSBezierPath {
		return NSBezierPath(rect: rect)
	}

    func draw(for segment: Int, in rect: NSRect) {
        guard let font = self.font else {
            Log.warning("No font for button")
            return
        }

        let textColor: NSColor = self.selectedSegment == segment ? .white : self.tintColor

        let style = NSMutableParagraphStyle()
        style.alignment = .center

        let attributes = [NSAttributedStringKey.font: font,
                          NSAttributedStringKey.foregroundColor: textColor,
                          NSAttributedStringKey.paragraphStyle: style]

        let attributedString = NSAttributedString(string: self.label(forSegment: segment) ?? "", attributes: attributes)

        var textFrame = NSRect(x: rect.origin.x,
                               y: -3.5,
                               width: rect.width,
                               height: 22)
        textFrame.center = rect.center

        attributedString.draw(in: textFrame)
    }
}
