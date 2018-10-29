//
//  ClickableTextField.swift
//  TranslateBar
//
//  Created by abobrov on 30/08/2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa
import RxSwift

class ClickableTextField: NSTextField, MouseTrackable, Highlightable {
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                highlight()
            } else {
                unhighlight()
            }
        }
    }

    func highlight() {
        backgroundColor = NSColor.gray.withAlphaComponent(0.3)
        NSCursor.pointingHand.set()
        layer?.cornerRadius = 3
    }

    func unhighlight() {
        NSCursor.arrow.set()
        backgroundColor = .clear
        layer?.cornerRadius = 0
    }

    var mouseTrackingArea: NSTrackingArea?

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    func setup() {
        addTrackingArea(with: [.activeInActiveApp, .mouseEnteredAndExited])
    }

    override func layout() {
        super.layout()
        removeTrackingArea()
        addTrackingArea(with: [.activeInActiveApp, .mouseEnteredAndExited])
    }

    override func mouseEntered(with event: NSEvent) {
        isHighlighted = true
    }

    override func mouseExited(with event: NSEvent) {
        isHighlighted = false
    }
}
