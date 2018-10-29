//
//  TranslationView.swift
//  TranslateBar
//
//  Created by Artem Bobrov on 27/10/2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa

class TranslationInput: View {
    @IBOutlet var textView: LimitedTextView!
    @IBOutlet var suggestionField: NSTextField!
    @IBOutlet var contentLengthField: NSTextField!
    @IBOutlet var closeButton: NSButton!
}

class TranslationOutput: NSStackView {
    @IBOutlet var textView: NSTextView!
    @IBOutlet var contentTableView: NSTableView!
}

class TranslationView: NSStackView {
    @IBOutlet var input: TranslationInput!
    @IBOutlet var output: TranslationOutput!
}
