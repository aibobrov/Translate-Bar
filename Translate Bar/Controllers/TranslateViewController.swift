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

		translateVM.inputText
			.map { $0?.contains(" ") ?? true }
			.subscribe { event in
				self.suggestTextLabel.isHidden = event.element ?? true
			}
			.disposed(by: disposeBag)
		translateVM.inputText
			.map({$0?.count ?? 0})
			.subscribe(onNext: { [unowned self] value in
				self.inputTextViewLimitationLabel.stringValue = "\(value)/\(self.inputTextView.maxCharactersCount)"
			}, onError: { error in
				Log.error(error)
			}, onCompleted: {
				Log.verbose("inputText sequence finished")
			}, onDisposed: nil)
			.disposed(by: disposeBag)
		translateVM.inputText
            .subscribe { [unowned self] _ in
               self.resizeAccordingToContent()
            }
            .disposed(by: disposeBag)
        translateVM.outputText
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
