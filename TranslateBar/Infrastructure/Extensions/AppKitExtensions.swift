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
        return NSApplication.shared.delegate as! AppDelegate
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

extension NSView {
    @IBInspectable
    var backgroundColor: NSColor {
        get {
            guard let cgColor = layer!.backgroundColor else { return .clear }
            return NSColor(cgColor: cgColor) ?? .clear
        }
        set {
            if layer == nil {
                wantsLayer = true
            }
            layer!.backgroundColor = newValue.cgColor
        }
    }

    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer!.cornerRadius
        }
        set {
            if layer == nil {
                wantsLayer = true
            }
            layer!.cornerRadius = newValue
        }
    }

    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        updateView()
    }

    private func updateView() {
        layer!.cornerRadius = cornerRadius
        layer!.backgroundColor = backgroundColor.cgColor
    }
}

extension NSScrollView {
    open override func invalidateIntrinsicContentSize() {
        super.invalidateIntrinsicContentSize()
        superview?.invalidateIntrinsicContentSize()
    }
}

extension NSStackView {
    open override func invalidateIntrinsicContentSize() {
        super.invalidateIntrinsicContentSize()
        superview?.invalidateIntrinsicContentSize()
    }
}

extension NSTableCellView {
    open override func invalidateIntrinsicContentSize() {
        super.invalidateIntrinsicContentSize()
        superview?.invalidateIntrinsicContentSize()
        enclosingScrollView?.invalidateIntrinsicContentSize()
    }
}
