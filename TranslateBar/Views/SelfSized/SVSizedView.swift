//
//  SVSizedView.swift
//  TranslateBar
//
//  Created by Artem Bobrov on 08/11/2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa

class SVSizedView: NSView {
    override func invalidateIntrinsicContentSize() {
        super.invalidateIntrinsicContentSize()
        superview?.invalidateIntrinsicContentSize()
    }
}
