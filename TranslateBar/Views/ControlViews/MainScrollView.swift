//
//  MainScrollView.swift
//  TranslateBar
//
//  Created by Artem Bobrov on 09/11/2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa

class MainScrollView: SelfSizedScrollView {
    override var intrinsicContentSize: NSSize {
        var size = super.intrinsicContentSize
        let visibleFrame = NSScreen.main!.visibleFrame
        size.height = min(size.height, visibleFrame.height - visibleFrame.origin.y)
        size.width = min(size.width, visibleFrame.width - visibleFrame.origin.x)
        return size
    }
}
