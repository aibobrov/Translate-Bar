//
//  TranslationTableCellView.swift
//  TranslateBar
//
//  Created by Artem Bobrov on 05.08.2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa
import RxCocoa
import RxSwift

class TranslationTableCellView: NSTableCellView, Customizable {
    @IBOutlet var translationTextLabel: ClickableTextField!
    @IBOutlet var numberLabel: NSTextField!

    private let disposeBag = DisposeBag()

    override func viewWillDraw() {
        super.viewWillDraw()
        if !isSetuped,
            let viewController = self.parentViewController as? TranslateViewController {
            setupBinding(for: viewController)
        }
    }

    private var isSetuped: Bool = false

    func setup(with data: DictionaryArticle.DictionaryTranslation, for row: Int) {
        numberLabel.stringValue = "\(row + 1)."
        translationTextLabel.stringValue = data.text
    }

    private func setupBinding(for viewController: TranslateViewController) {
        guard !isSetuped else { return }
        isSetuped = true
        translationTextLabel.rx
            .mouseDown
            .subscribe(onNext: { textField in
                textField.isHighlighted = false
//                viewController.translateVM.swap()
//                viewController.translateVM.rawInput.accept(textField.stringValue)
            })
            .disposed(by: disposeBag)
    }
}
