//
//  TextView.swift
//  TranslateBar
//
//  Created by Artem Bobrov on 13.06.2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa

@IBDesignable
class TextView: NSTextView {
    override var intrinsicContentSize: NSSize {
        guard let manager = textContainer?.layoutManager else { return .zero }
        manager.ensureLayout(for: textContainer!)
        return manager.usedRect(for: textContainer!).size
    }

    override var readablePasteboardTypes: [NSPasteboard.PasteboardType] {
        return [NSPasteboard.PasteboardType.string]
    }
}
