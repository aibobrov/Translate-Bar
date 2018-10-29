//
//  ImageView.swift
//  TranslateBar
//
//  Created by Artem Bobrov on 29.06.2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa

class ImageView: NSImageView {
    @IBInspectable
    var backgroundColor: NSColor = .clear {
        didSet {
            layer?.backgroundColor = backgroundColor.cgColor
        }
    }

    @IBInspectable
    var cornerRadius: CGFloat = 0 {
        didSet {
            layer?.cornerRadius = cornerRadius
        }
    }

    @IBInspectable
    var imageTintColor: NSColor = .clear {
        didSet {
            self.image = self.image?.tinted(by: imageTintColor)
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
        image = image?.tinted(by: imageTintColor)
    }
}
