//
//  NSImageExtension.swift
//  Translate Bar
//
//  Created by Artem Bobrov on 18.06.2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa

extension NSImage {

	func tinted(by color: NSColor) -> NSImage {
		guard let tinted = self.copy() as? NSImage else { return self }
		tinted.lockFocus()
		color.set()

		let imageRect = NSRect(origin: .zero, size: self.size)
		__NSRectFillUsingOperation(imageRect, .sourceAtop)
		tinted.unlockFocus()
		return tinted
	}

}
