//
//  NSRectExtensions.swift
//  Translate Bar
//
//  Created by Artem Bobrov on 18.06.2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa

extension NSRect {
	var center: NSPoint {
		get {
			return NSPoint(x: minX + width / 2, y: minY + height / 2)
		}
		set {
			self.origin = NSPoint(x: newValue.x - width / 2, y: newValue.y - height / 2)
		}
	}

	func scaledToFit(bounds: NSRect, with diff: CGFloat = 0) -> NSRect {
		var bounds = bounds
		let oldCenter = bounds.center
		bounds.size.width -= diff
		bounds.size.height -= diff
		let scale = min(bounds.width / width, bounds.height / height)
		var rect = NSRect(origin: .zero, size: CGSize(width: width * scale, height: height * scale))
		rect.center = oldCenter
		return rect
	}
}
