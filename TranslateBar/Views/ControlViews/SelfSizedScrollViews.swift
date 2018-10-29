//
//  SelfSizedScrollView.swift
//  TranslateBar
//
//  Created by Artem Bobrov on 30.08.2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa

// swiftlint:disable block_based_kvo

class SelfSizedScrollView: ScrollView {
    private var _heightConstaint: NSLayoutConstraint!

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        _heightConstaint = NSLayoutConstraint(
            item: self,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1,
            constant: bounds.height
        )
        _heightConstaint.isActive = true
        _heightConstaint.priority = NSLayoutConstraint.Priority(rawValue: 999)

        addObserver(self, forKeyPath: #keyPath(SelfSizedScrollView.documentView.intrinsicContentSize), options: .new, context: nil)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentLayoutRect",
            let height = self.documentView?.frame.height,
            height != _heightConstaint.constant {
            _heightConstaint.constant = height
            layoutSubtreeIfNeeded()
        }
    }

    deinit {
        self.removeObserver(self, forKeyPath: #keyPath(SelfSizedScrollView.documentView.intrinsicContentSize))
    }
}
