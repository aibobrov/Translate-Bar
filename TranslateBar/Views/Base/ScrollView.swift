//
//  ScrollView.swift
//  TranslateBar
//
//  Created by abobrov on 21/06/2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa

class ScrollView: NSScrollView {
    override func scrollWheel(with event: NSEvent) {
        enclosingScrollView?.scrollWheel(with: event)
    }

    override func scroll(_ point: NSPoint) {
        enclosingScrollView?.scroll(point)
    }

    override func scrollLineUp(_ sender: Any?) {
        enclosingScrollView?.scrollLineUp(sender)
    }

    override func scrollLineDown(_ sender: Any?) {
        enclosingScrollView?.scrollLineDown(sender)
    }

    override func scrollPageUp(_ sender: Any?) {
        enclosingScrollView?.scrollPageUp(sender)
    }

    override func scrollPageDown(_ sender: Any?) {
        enclosingScrollView?.scrollPageDown(sender)
    }

    override func scrollToBeginningOfDocument(_ sender: Any?) {
        enclosingScrollView?.scrollToBeginningOfDocument(sender)
    }

    override func scrollToEndOfDocument(_ sender: Any?) {
        enclosingScrollView?.scrollToEndOfDocument(sender)
    }

    override func scroll(_ clipView: NSClipView, to point: NSPoint) {
        enclosingScrollView?.scroll(clipView, to: point)
    }

    override func scroll(_ rect: NSRect, by delta: NSSize) {
        enclosingScrollView?.scroll(rect, by: delta)
    }
}
