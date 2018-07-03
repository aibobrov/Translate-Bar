//
//  NSPasteboardExtension.swift
//  Translate Bar
//
//  Created by abobrov on 02/07/2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa
extension NSPasteboard {
    static var clipboard: String? {
        return NSPasteboard.general.pasteboardItems?.first?.string(forType: .string)
    }
}
