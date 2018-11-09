//
//  LanguageCollectionViewItem.swift
//  TranslateBar
//
//  Created by Artem Bobrov on 30.06.2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa

class LanguageCollectionViewItem: NSCollectionViewItem, Highlightable, MouseTrackable, Configurable {
    var isHighlighted: Bool = false {
        didSet {
            if isHighlighted {
                highlight()
            } else {
                unhighlight()
            }
        }
    }

    override func mouseEntered(with event: NSEvent) {
        super.mouseEntered(with: event)
        isHighlighted = true
    }

    override func mouseExited(with event: NSEvent) {
        super.mouseEntered(with: event)
        isHighlighted = false
    }

    func highlight() {
        view.layer?.borderWidth = 0.5
        view.layer?.borderColor = NSColor.alternateSelectedControlColor.cgColor
        view.layer?.backgroundColor = NSColor.controlColor.cgColor
    }

    func unhighlight() {
        view.layer?.borderWidth = 0
        view.layer?.backgroundColor = NSColor.clear.cgColor
    }

    var mouseTrackingArea: NSTrackingArea?

    override func viewDidLoad() {
        super.viewDidLoad()
        addTrackingArea(with: [.activeInActiveApp, .mouseEnteredAndExited])
    }

    override func viewDidLayout() {
        super.viewDidLayout()
        removeTrackingArea()
        addTrackingArea(with: [.activeInActiveApp, .mouseEnteredAndExited])
    }

    func configure(with language: Language) {
        imageView!.image = NSImage(named: language.imageName)
        textField!.stringValue = language.description
    }
}
