//
//  HalfRoundedBezierPath.swift
//  Translate Bar
//
//  Created by Artem Bobrov on 15.06.2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa

class HalfRoundedBezierPath {
	enum Side {
		case top
		case bottom
		case left
		case right
	}

	static func rightRoundedPath(in bounds: NSRect, with cornerRadius: CGFloat) -> NSBezierPath {
		let bezier = NSBezierPath()

		bezier.move(to: NSPoint(x: bounds.minX, y: bounds.minY))
		bezier.line(to: NSPoint(x: bounds.maxX - cornerRadius, y: bounds.minY))
		bezier.appendArc(withCenter: NSPoint(x: bounds.maxX - cornerRadius, y: cornerRadius), radius: cornerRadius, startAngle: 270, endAngle: 360)
		bezier.line(to: NSPoint(x: bounds.maxX, y: bounds.maxY - cornerRadius))
		bezier.appendArc(withCenter: NSPoint(x: bounds.maxX - cornerRadius, y: bounds.maxY - cornerRadius), radius: cornerRadius, startAngle: 0, endAngle: 90)

		bezier.line(to: NSPoint(x: bounds.minX, y: bounds.maxY))
		bezier.close()
		return bezier
	}

	static func leftRoundedPath(in bounds: NSRect, with cornerRadius: CGFloat) -> NSBezierPath {
		let bezier = NSBezierPath()

		bezier.move(to: NSPoint(x: bounds.maxX, y: bounds.minY))
		bezier.line(to: NSPoint(x: bounds.maxX, y: bounds.maxY))
		bezier.line(to: NSPoint(x: cornerRadius, y: bounds.maxY))
		bezier.appendArc(withCenter: NSPoint(x: cornerRadius, y: bounds.maxY - cornerRadius), radius: cornerRadius, startAngle: 90, endAngle: 180)
		bezier.line(to: NSPoint(x: bounds.minX, y: cornerRadius))
		bezier.appendArc(withCenter: NSPoint(x: cornerRadius, y: cornerRadius), radius: cornerRadius, startAngle: 180, endAngle: 270)
		bezier.close()

		return bezier
	}

	static func topRoundedPath(in bounds: NSRect, with cornerRadius: CGFloat) -> NSBezierPath {
		let bezier = NSBezierPath()

		bezier.move(to: NSPoint(x: bounds.maxX - cornerRadius, y: bounds.minY))
		bezier.appendArc(withCenter: NSPoint(x: bounds.maxX - cornerRadius, y: cornerRadius), radius: cornerRadius, startAngle: 90, endAngle: 0)
		bezier.line(to: NSPoint(x: bounds.maxX, y: bounds.maxY))
		bezier.line(to: NSPoint(x: bounds.minX, y: bounds.maxY))
		bezier.line(to: NSPoint(x: bounds.minX, y: bounds.maxY - cornerRadius))
		bezier.appendArc(withCenter: NSPoint(x: cornerRadius, y: cornerRadius), radius: cornerRadius, startAngle: 180, endAngle: 270)
		bezier.close()

		return bezier
	}

	static func bottomRoundedPath(in bounds: NSRect, with cornerRadius: CGFloat) -> NSBezierPath {
		let bezier = NSBezierPath()

		bezier.move(to: NSPoint(x: bounds.minX, y: bounds.minY))
		bezier.line(to: NSPoint(x: bounds.maxX, y: bounds.minY))
		bezier.line(to: NSPoint(x: bounds.maxX, y: bounds.maxY - cornerRadius))
		bezier.appendArc(withCenter: NSPoint(x: bounds.maxX - cornerRadius, y: bounds.maxY - cornerRadius), radius: cornerRadius, startAngle: 0, endAngle: 90)
		bezier.line(to: NSPoint(x: cornerRadius, y: bounds.maxY))
		bezier.appendArc(withCenter: NSPoint(x: cornerRadius, y: bounds.maxY - cornerRadius), radius: cornerRadius, startAngle: 90, endAngle: 180)
		bezier.close()

		return bezier
	}

	static func path(for side: Side, in rect: NSRect, with cornerRadius: CGFloat) -> NSBezierPath {
		switch side {
		case .left:
			return leftRoundedPath(in: rect, with: cornerRadius)
		case .top:
			return topRoundedPath(in: rect, with: cornerRadius)
		case .right:
			return rightRoundedPath(in: rect, with: cornerRadius)
		case .bottom:
			return bottomRoundedPath(in: rect, with: cornerRadius)
		}
	}
}
