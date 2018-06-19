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
	@IBOutlet weak var InputTextView: LimitedTextView!
	@IBOutlet weak var OutputTextView: NSTextView!

	@IBOutlet weak var InputTextViewLimitationLabel: NSTextField!
	@IBOutlet weak var SuggestTextLabel: NSTextField!
	@IBOutlet weak var TextHeightConstraint: NSLayoutConstraint!
	@IBOutlet weak var InputTextViewSuggestLabelBottomConstraint: NSLayoutConstraint!
	@IBOutlet weak var InputTextViewSuperViewBottomSpaceConstraint: NSLayoutConstraint!

	let translateVM = TranslateViewModel()
	private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
		setupBindings()

		translateVM.inputText
			.map { $0?.contains(" ") ?? true }
			.subscribe { event in
				self.SuggestTextLabel.isHidden = event.element ?? true
			}
			.disposed(by: disposeBag)
		translateVM.inputText
			.map({$0?.count ?? 0})
			.subscribe(onNext: { [unowned self] value in
				self.InputTextViewLimitationLabel.stringValue = "\(value)/\(self.InputTextView.maxCharactersCount)"
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
		InputTextView.rx.text
			.bind(to: translateVM.inputText)
			.disposed(by: disposeBag)
		translateVM.outputText
			.bind(to: OutputTextView.rx.text)
			.disposed(by: disposeBag)
	}

    private func resizeAccordingToContent() {
		let extraSpace = self.TextHeightConstraint.constant + self.InputTextViewLimitationLabel.frame.height - min(self.InputTextView.frame.height, self.OutputTextView.frame.height) // swiftlint:disable:this trailing_whitespace
        let maxTextHeight = max(self.InputTextView.intrinsicContentSize.height, self.OutputTextView.intrinsicContentSize.height) + extraSpace
        let screenHeight = NSScreen.main?.frame.height ?? 0
        self.TextHeightConstraint.constant = max(200, maxTextHeight)
        let appDelegate = NSApplication.shared.delegate as! AppDelegate // swiftlint:disable:this force_cast
        appDelegate.popover.contentSize.height = min(appDelegate.popover.contentSize.height, screenHeight)
    }
}
