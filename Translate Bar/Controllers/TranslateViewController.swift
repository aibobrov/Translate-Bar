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
    @IBOutlet weak var contentView: NSView!
    @IBOutlet weak var mainScrollView: NSScrollView!
    @IBOutlet weak var inputTextView: LimitedTextView!
	@IBOutlet weak var outputTextView: NSTextView!

	@IBOutlet weak var inputTextViewLimitationLabel: NSTextField!
	@IBOutlet weak var clearButton: NSButton!
	@IBOutlet weak var suggestTextLabel: NSTextField!
	@IBOutlet weak var textContainerHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var sourceLanguageSegmentedControl: NSSegmentedControl!
    let translateVM = TranslateViewModel()
	private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
		setupUIBindings()
        setupViewModelBindings()
    }

    override func viewDidAppear() {
        super.viewDidAppear()
        NSApplication.shared.activate(ignoringOtherApps: true)
    }

	private func setupUIBindings() {
		inputTextView.rx.text
            .distinctUntilChanged()
            .filter({$0 != nil && $0!.count > 0})
            .map { $0! }
            .bind(to: translateVM.inputText)
			.disposed(by: disposeBag)
		translateVM.inputText
			.bind(to: inputTextView.rx.text)
			.disposed(by: disposeBag)
		translateVM.outputText
			.bind(to: outputTextView.rx.text)
			.disposed(by: disposeBag)

		clearButton.rx
			.controlEvent.map {""}
			.bind(to: translateVM.inputText)
			.disposed(by: disposeBag)
	}
    private func setupViewModelBindings() {
        translateVM.clearButtonHidden
            .bind(to: self.clearButton.rx.isHidden)
            .disposed(by: disposeBag)
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

    private func resizeAccordingToContent() {
		let extraSpace = self.textContainerHeightConstraint.constant + self.inputTextViewLimitationLabel.frame.height - min(self.inputTextView.frame.height, self.outputTextView.frame.height) // swiftlint:disable:this trailing_whitespace
        let maxTextContentHeight = max(self.inputTextView.intrinsicContentSize.height, self.outputTextView.intrinsicContentSize.height)
        let maxTextContainerHeight = maxTextContentHeight + extraSpace
        self.textContainerHeightConstraint.constant = max(200, maxTextContainerHeight)

        DispatchQueue.main.async {
            let appDelegate = NSApplication.shared.delegate as! AppDelegate // swiftlint:disable:this force_cast
            appDelegate.popover.contentSize.height = self.contentView.frame.height
            self.view.layoutSubtreeIfNeeded()
        }
    }
}
