//
//  LanguageSearch.swift
//  TranslateBar
//
//  Created by Artem Bobrov on 27/10/2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa

class LanguageSearch: SVSizedView {
    @IBOutlet var contentCollectionView: NSCollectionView!
    @IBOutlet var searchTextField: NSTextField!

    override func invalidateIntrinsicContentSize() {
        super.invalidateIntrinsicContentSize()
        superview?.invalidateIntrinsicContentSize()
    }
}
