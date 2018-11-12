//
//  SelfSizedTableView.swift
//  TranslateBar
//
//  Created by Artem Bobrov on 10/11/2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa

class SelfSizedTableView: NSTableView {
    override func reloadData() {
        super.reloadData()
        invalidateIntrinsicContentSize()
    }

    override var intrinsicContentSize: NSSize {
        var size = super.intrinsicContentSize
        size.width = bounds.width
        return size
    }

    override func invalidateIntrinsicContentSize() {
        super.invalidateIntrinsicContentSize()
        enclosingScrollView?.invalidateIntrinsicContentSize()
    }
}
