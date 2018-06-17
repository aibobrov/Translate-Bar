//
//  SidedRoundedButtonCell.swift
//  Translate Bar
//
//  Created by Artem Bobrov on 16.06.2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa

class LeftSideRoundedButtonCell: CustomRoundedButtonCell {
	override func path(for rect: NSRect) -> NSBezierPath {
		return HalfRoundedBezierPath.path(for: .left, in: rect, with: cornerRadius)
	}
}

class RightSideRoundedButtonCell: CustomRoundedButtonCell {
	override func path(for rect: NSRect) -> NSBezierPath {
		return HalfRoundedBezierPath.path(for: .right, in: rect, with: cornerRadius)
	}
}

class RoundedButtonCell: CustomRoundedButtonCell {
	override func draw(withFrame cellFrame: NSRect, in controlView: NSView) {
		super.draw(withFrame: cellFrame, in: controlView)
		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(100)) {
			self.state = .off
		}

	}

	override func path(for rect: NSRect) -> NSBezierPath {
		return NSBezierPath(roundedRect: rect, xRadius: cornerRadius, yRadius: cornerRadius)
	}
}
