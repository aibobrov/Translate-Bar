//
//  ScrollView.swift
//  Translate Bar
//
//  Created by abobrov on 21/06/2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa

class ScrollView: NSScrollView {

    override func scrollWheel(with event: NSEvent) {
        self.enclosingScrollView?.scrollWheel(with: event)
    }

	override func scroll(_ point: NSPoint) {
        self.enclosingScrollView?.scroll(point)
    }

	override func scrollLineUp(_ sender: Any?) {
        self.enclosingScrollView?.scrollLineUp(sender)
    }

	override func scrollLineDown(_ sender: Any?) {
        self.enclosingScrollView?.scrollLineDown(sender)
    }

	override func scrollPageUp(_ sender: Any?) {
        self.enclosingScrollView?.scrollPageUp(sender)
    }

	override func scrollPageDown(_ sender: Any?) {
        self.enclosingScrollView?.scrollPageDown(sender)
    }

	override func scrollToBeginningOfDocument(_ sender: Any?) {
        self.enclosingScrollView?.scrollToBeginningOfDocument(sender)
    }

	override func scrollToEndOfDocument(_ sender: Any?) {
        self.enclosingScrollView?.scrollToEndOfDocument(sender)
    }

	override func scroll(_ clipView: NSClipView, to point: NSPoint) {
        self.enclosingScrollView?.scroll(clipView, to: point)
    }

	override func scroll(_ rect: NSRect, by delta: NSSize) {
        self.enclosingScrollView?.scroll(rect, by: delta)
    }

}
