//
//  DictionaryTableCellView.swift
//  TranslateBar
//
//  Created by Artem Bobrov on 04.08.2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa

class DictionaryTableCellView: NSTableCellView, Customizable {
    @IBOutlet var textLabel: NSTextField!
    @IBOutlet var transcriptionLabel: NSTextField!
    @IBOutlet var posLabel: NSTextField!
    @IBOutlet var translationTableView: NSTableView!
    @IBOutlet var translationTableViewHeightConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        translationTableView.dataSource = self
        translationTableView.delegate = self
    }

    private var article: DictionaryArticle?

    func setup(with data: DictionaryArticle, for row: Int) {
        article = data
        textLabel.stringValue = data.text
        if let transcription = data.transcription {
            transcriptionLabel.stringValue = "[\(transcription)]"
        } else {
            transcriptionLabel.isHidden = true
        }
        if let partOfSpeech = data.partOfSpeech {
            posLabel.stringValue = partOfSpeech
        } else {
            posLabel.isHidden = true
        }

        DispatchQueue.main.async {
            self.translationTableView.reloadData()
        }
        DispatchQueue.main.async {
            self.translationTableViewHeightConstraint.constant = self.translationTableView.fittingSize.height
            self.layoutSubtreeIfNeeded()
        }
        DispatchQueue.main.async {
            (self.superview?.superview as? TableView)?.cellSizeChanged.onNext(self)
        }
    }
}

extension DictionaryTableCellView: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return article?.translations.count ?? 0
    }
}

extension DictionaryTableCellView: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let view = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "TranslationTableCellView"), owner: self) as! TranslationTableCellView // swiftlint:disable:this force_cast
        if let translation = article?.translations[row] {
            view.setup(with: translation, for: row)
        }
        return view
    }
}
