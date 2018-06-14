//
//  HalfRoundedView.swift
//  Translate Bar
//
//  Created by Artem Bobrov on 14.06.2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa

class HalfRoundedButton: NSButton {
	lazy var shapedLayer: CAShapeLayer = {
		let layer = CAShapeLayer()

		layer.fillColor = NSColor.blue.cgColor
		layer.path = bezierPath.cgPath
		return layer
	}()

	var bezierPath: NSBezierPath {
		let bezier = NSBezierPath()
		bezier.move(to: .zero)

		bezier.line(to: NSPoint(x: bounds.width - cornerRadius, y: 0))
		bezier.appendArc(withCenter: NSPoint(x: bounds.width - cornerRadius, y: cornerRadius), radius: cornerRadius, startAngle: 90, endAngle: 0)
		bezier.line(to: NSPoint(x: bounds.width, y: bounds.height - cornerRadius))
		bezier.appendArc(withCenter: NSPoint(x: bounds.width - cornerRadius, y: bounds.height - cornerRadius), radius: cornerRadius, startAngle: 0, endAngle: 90)

		bezier.line(to: NSPoint(x: 0, y: bounds.height))
		bezier.close()

		return bezier
	}

	lazy var cornerRadius: CGFloat = 5

	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)!
		setup()
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}

	func setup() {
		self.wantsLayer = true
		self.layer?.backgroundColor = NSColor.clear.cgColor
		self.layer?.masksToBounds = true
		self.layer?.addSublayer(shapedLayer)
		self.layer?.insertSublayer(shapedLayer, below: self.layer!)
		shapedLayer.masksToBounds = true
		shapedLayer.frame = self.bounds
	}
}
