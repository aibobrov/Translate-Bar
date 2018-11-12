//
//  SelfSizedScrollView.swift
//  TranslateBar
//
//  Created by Artem Bobrov on 04/11/2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa

class SelfSizedScrollView: NSScrollView {
    override var intrinsicContentSize: NSSize {
        return documentView?.intrinsicContentSize ?? super.intrinsicContentSize
    }
}
