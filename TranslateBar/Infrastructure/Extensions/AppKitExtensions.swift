//
//  AppKitExtensions.swift
//  TranslateBar
//
//  Created by Artem Bobrov on 27/10/2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa

public extension NSResponder {
    public var parentViewController: NSViewController? {
        var responder: NSResponder? = self
        while responder != nil {
            if let viewController = responder as? NSViewController {
                return viewController
            }
            responder = responder?.nextResponder
        }
        return nil
    }
}

extension NSApplication {
    var appDelegate: AppDelegate {
        return NSApplication.shared.delegate as! AppDelegate // swiftlint:disable:this force_cast
    }
}

public extension NSPasteboard {
    static var clipboard: String? {
        return NSPasteboard.general.pasteboardItems?.first?.string(forType: .string)
    }
}

public extension NSImage {
    public func tinted(by color: NSColor) -> NSImage {
        guard let tinted = self.copy() as? NSImage else { return self }
        tinted.lockFocus()
        color.set()

        let imageRect = NSRect(origin: .zero, size: size)
        __NSRectFillUsingOperation(imageRect, .sourceAtop)
        tinted.unlockFocus()
        return tinted
    }
}
