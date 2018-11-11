//
//  DictionaryArticleCellView.swift
//  TranslateBar
//
//  Created by Artem Bobrov on 10/11/2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa
import RxCocoa
import RxSwift

class DictionaryArticleCellView: NSTableCellView, Configurable {
    @IBOutlet var wordTextField: NSTextField!
    @IBOutlet var transcriptionTextField: NSTextField!
    @IBOutlet var partOfSpeechTextField: NSTextField!
    @IBOutlet var genusTextField: NSTextField!
    @IBOutlet var translationTableView: NSTableView!

    override func awakeFromNib() {
        super.awakeFromNib()
        translationTableView.delegate = self
        translationTableView.dataSource = self
    }

    private var article: DictionaryArticle? {
        didSet {
            wordTextField.stringValue = article?.text ?? ""
            transcriptionTextField.applyOfHide(value: article?.transcription.map { "[\($0)]" })
            partOfSpeechTextField.applyOfHide(value: article?.partOfSpeech)
            genusTextField.applyOfHide(value: article?.genus)
            translationTableView.isHidden = article?.translations.isEmpty ?? true
            translationTableView.reloadData()
        }
    }

    func configure(with data: DictionaryArticle) {
        article = data
    }
}

extension DictionaryArticleCellView: NSTableViewDelegate, NSTableViewDataSource {
    func numberOfRows(in _: NSTableView) -> Int {
        return article?.translations.count ?? 0
    }

    func tableView(_ tableView: NSTableView, viewFor _: NSTableColumn?, row: Int) -> NSView? {
        let view = tableView.makeView(ofType: TranslationCellView.self)
        view.configure(with: (offset: row, element: article!.translations[row]))

        return view
    }
}
