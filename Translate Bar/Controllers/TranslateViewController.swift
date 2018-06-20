//
//  TranslateViewController.swift
//  Translate Bar
//
//  Created by Artem Bobrov on 13.06.2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa
import RxCocoa
import RxSwift

class TranslateViewController: NSViewController {
	@IBOutlet weak var inputTextView: LimitedTextView!
	@IBOutlet weak var outputTextView: NSTextView!

	@IBOutlet weak var inputTextViewLimitationLabel: NSTextField!
	@IBOutlet weak var suggestTextLabel: NSTextField!
	@IBOutlet weak var textContainerHeightConstraint: NSLayoutConstraint!

	let translateVM = TranslateViewModel()
	private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
		setupBindings()

        translateVM.isSuggestNeeded
            .bind(to: self.suggestTextLabel.rx.isHidden)
            .disposed(by: disposeBag)

        translateVM.limitationText
            .bind(to: self.inputTextViewLimitationLabel.rx.text)
            .disposed(by: disposeBag)

        translateVM.text
            .subscribe { [unowned self] _ in
                self.resizeAccordingToContent()
            }
            .disposed(by: disposeBag)
    }

	private func setupBindings() {
		inputTextView.rx.text
            .bind(to: translateVM.inputText)
			.disposed(by: disposeBag)
		translateVM.outputText
			.bind(to: outputTextView.rx.text)
			.disposed(by: disposeBag)
	}

    private func resizeAccordingToContent() {
		let extraSpace = self.textContainerHeightConstraint.constant + self.inputTextViewLimitationLabel.frame.height - min(self.inputTextView.frame.height, self.outputTextView.frame.height) // swiftlint:disable:this trailing_whitespace
        let maxTextHeight = max(self.inputTextView.intrinsicContentSize.height, self.outputTextView.intrinsicContentSize.height) + extraSpace
        let screenHeight = NSScreen.main?.frame.height ?? 0
        self.textContainerHeightConstraint.constant = max(200, maxTextHeight)
        let appDelegate = NSApplication.shared.delegate as! AppDelegate // swiftlint:disable:this force_cast
        appDelegate.popover.contentSize.height = min(appDelegate.popover.contentSize.height, screenHeight)
    }
}
