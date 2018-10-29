//
//  Button.swift
//  TranslateBar
//
//  Created by Artem Bobrov on 21.06.2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa

class Button: NSButton {
    @IBInspectable
    var backgroundColor: NSColor = .clear {
        didSet {
            layer?.backgroundColor = backgroundColor.cgColor
        }
    }

    @IBInspectable
    var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer?.cornerRadius = cornerRadius
        }
    }

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setup()
    }

    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        setup()
    }

    private func setup() {
        wantsLayer = true
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        layer?.cornerRadius = cornerRadius
        layer?.backgroundColor = backgroundColor.cgColor
    }
}
