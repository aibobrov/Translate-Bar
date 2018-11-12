//
//  LimitedTextView.swift
//  Translate Bar
//
//  Created by Artem Bobrov on 18.06.2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa

class LimitedTextView: SelfSizedTextView {
    @IBInspectable
    var maxCharactersCount: Int = .max

    func textView(_ textView: NSTextView, shouldChangeTextIn affectedCharRange: NSRange, replacementString: String?) -> Bool {
        let text = textView.string
        guard let stringRange = Range(affectedCharRange, in: text) else { return false }
        let updatedText = text.replacingCharacters(in: stringRange, with: replacementString ?? "")
        return updatedText.count <= maxCharactersCount
    }
}
