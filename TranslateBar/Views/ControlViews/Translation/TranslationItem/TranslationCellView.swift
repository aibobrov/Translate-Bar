//
//  TranslationCellView.swift
//  TranslateBar
//
//  Created by Artem Bobrov on 10/11/2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa
import RxCocoa
import RxSwift

class TranslationCellView: NSTableCellView, Configurable {
    @IBOutlet var numberLabel: NSTextField!
    @IBOutlet var textView: NSTextView!
    @IBOutlet var exampleTextView: NSTextView!
    private let disposeBag = DisposeBag()
    private lazy var linkAction = TableCellViewAction<OnLinkActionQuery>(.linkClicked)
    override func awakeFromNib() {
        super.awakeFromNib()
        textView.linkTextAttributes = [
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
            NSAttributedString.Key.cursor: NSCursor.pointingHand
        ]

        textView.rx.linkClicked
            .map { $0.0 as! String }
            .subscribe(onNext: { [weak sender = linkAction] text in
                let result = text.split(separator: TranslateClickAction.separator).map(String.init)
                let action = TranslateClickAction(rawValue: result.last!)!
                let query = String(result.dropLast().joined())
                sender?.invoke(on: self, object: OnLinkActionQuery(action: action, query: query))
            })
            .disposed(by: disposeBag)
    }

    func configure(with translation: (offset: Int, element: DictionaryArticle.DictionaryTranslation)) {
        numberLabel.stringValue = "\(translation.offset + 1)."
        let main = [self.translation(for: translation.element), self.meaning(for: translation.element)]
            .filter { !$0.string.isEmpty }
            .joined(separator: "\n")
            .applying(.font(FontFamily.Roboto.regular.font(size: 13)))

        textView.textStorage!.setAttributedString(main)

        let examples = self.examples(for: translation.element).applying(.font(FontFamily.Roboto.regular.font(size: 13)))
        exampleTextView.textStorage!.setAttributedString(examples)
        exampleTextView.enclosingScrollView!.isHidden = examples.string.isEmpty
    }

    private func translation(for translation: DictionaryArticle.DictionaryTranslation) -> NSAttributedString {
        let words = [translation.text] + (translation.synonyms?.map { $0.text } ?? [])
        return words
            .map { NSMutableAttributedString(string: $0).applying(.link("\($0)\(TranslateClickAction.separator)\(TranslateClickAction.swap.rawValue)")) }
            .joined(separator: ", ")
            .applying(.foregroundColor(.linkColor))
    }

    private func meaning(for translation: DictionaryArticle.DictionaryTranslation) -> NSAttributedString {
        return translation.meanings?.map { mean in
            let kernel = NSMutableAttributedString(string: mean.text).applying(.link("\(mean.text)\(TranslateClickAction.separator)\(TranslateClickAction.keep.rawValue)"))
            return NSAttributedString(string: "(") + kernel + NSAttributedString(string: ")")
        }
        .joined(separator: ", ")
        .applying(.foregroundColor(.systemRed)) ?? NSAttributedString(string: "")
    }

    private func examples(for translation: DictionaryArticle.DictionaryTranslation) -> NSAttributedString {
        return translation.examples?.map {
            var string = $0.text
            if let translationText = $0.translations.first?.text {
                string += " – \(translationText)"
            }
            return string
        }
        .map { NSMutableAttributedString(string: $0) }
        .joined(separator: "\n")
        .applying(.foregroundColor(.systemGray)) ?? NSAttributedString(string: "")
    }
}
