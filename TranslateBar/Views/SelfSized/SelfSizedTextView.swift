//
//  SelfSizedTextView.swift
//  TranslateBar
//
//  Created by Artem Bobrov on 04/11/2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa

class SelfSizedTextView: NSTextView, NSTextViewDelegate {
    @IBInspectable
    var minHeight: CGFloat = -.infinity

    private weak var _delegate: NSTextViewDelegate?

    override var delegate: NSTextViewDelegate? {
        get {
            return _delegate
        }
        set {
            _delegate = newValue
        }
    }

    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setup()
    }

    public override init(frame frameRect: NSRect, textContainer container: NSTextContainer?) {
        super.init(frame: frameRect, textContainer: container)
        setup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        super.delegate = self
    }

    override var intrinsicContentSize: NSSize {
        guard let manager = textContainer?.layoutManager else { return super.intrinsicContentSize }
        manager.ensureLayout(for: textContainer!)
        var size = manager.usedRect(for: textContainer!).size
        size.height = max(size.height, minHeight)
        return size
    }

    override var readablePasteboardTypes: [NSPasteboard.PasteboardType] {
        return [NSPasteboard.PasteboardType.string]
    }

    public func textDidChange(_ notification: Notification) {
        invalidateIntrinsicContentSize()
        _delegate?.textDidChange?(notification)
    }

    override func invalidateIntrinsicContentSize() {
        super.invalidateIntrinsicContentSize()
        enclosingScrollView?.invalidateIntrinsicContentSize()
    }
}
