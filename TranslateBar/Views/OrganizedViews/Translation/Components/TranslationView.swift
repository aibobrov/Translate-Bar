//
//  TranslationView.swift
//  TranslateBar
//
//  Created by Artem Bobrov on 27/10/2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa

class TranslationInput: SVSizedView {
    @IBOutlet var textView: LimitedTextView!
    @IBOutlet var suggestionTextView: NSTextView!
    @IBOutlet var contentLengthField: NSTextField!
    @IBOutlet var closeButton: NSButton!
}

class TranslationTextOutput: SVSizedView {
    @IBOutlet var textView: NSTextView!
}

class TranslationArticleOutput: SVSizedView {
    @IBOutlet var contentTableView: NSTableView!
}

class TranslationOutput: NSStackView {
    @IBOutlet var translationText: TranslationTextOutput!
    @IBOutlet var translationArticle: TranslationArticleOutput!
}

class TranslationView: NSStackView {
    @IBOutlet var input: TranslationInput!
    @IBOutlet var output: TranslationOutput!
}
