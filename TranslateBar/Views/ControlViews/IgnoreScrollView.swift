//
//  IgnoreScrollView.swift
//  TranslateBar
//
//  Created by Artem Bobrov on 06/11/2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa

class IgnoreScrollView: SelfSizedScrollView {
    override func scrollWheel(with event: NSEvent) {
        enclosingScrollView?.scrollWheel(with: event)
    }
}
