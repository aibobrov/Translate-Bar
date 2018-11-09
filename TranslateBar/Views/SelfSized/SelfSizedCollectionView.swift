//
//  SelfSizedCollectionView.swift
//  TranslateBar
//
//  Created by Artem Bobrov on 06/11/2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa

class SelfSizedCollectionView: NSCollectionView {
    override func reloadData() {
        super.reloadData()
        invalidateIntrinsicContentSize()
    }

    override var intrinsicContentSize: NSSize {
        return collectionViewLayout?.collectionViewContentSize ?? super.intrinsicContentSize
    }

    override func invalidateIntrinsicContentSize() {
        super.invalidateIntrinsicContentSize()
        enclosingScrollView?.invalidateIntrinsicContentSize()
    }
}
