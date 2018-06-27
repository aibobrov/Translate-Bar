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

    @IBOutlet weak var sourceLanguageSegmentedControl: SegmentedControl!
    @IBOutlet weak var targetLanguageSegmentedControl: SegmentedControl!

    let translateVM = TranslateViewModel()
	private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        inputTextView.maxCharactersCount = translateVM.maxCharactersCount
        sourceLanguageSegmentedControl.singleSelectionSegments = (0..<sourceLanguageSegmentedControl.segmentCount - 1).map { $0 }
        targetLanguageSegmentedControl.singleSelectionSegments = (0..<targetLanguageSegmentedControl.segmentCount - 1).map { $0 }

		setupUIBindings()
        setupViewModelBindings()
    }

    override func viewDidAppear() {
        super.viewDidAppear()
        NSApplication.shared.activate(ignoringOtherApps: true)
    }

	private func setupUIBindings() {
		inputTextView.rx.text
            .bind(to: translateVM.rawInput)
			.disposed(by: disposeBag)

        translateVM.rawInput
            .bind(to: inputTextView.rx.text)
            .disposed(by: disposeBag)

        translateVM.rawOutput
			.bind(to: outputTextView.rx.text)
			.disposed(by: disposeBag)

		clearButton.rx
			.controlEvent.map { "" }
			.bind(to: translateVM.rawInput)
			.disposed(by: disposeBag)

        sourceLanguageSegmentedControl.rx.value
            .distinctUntilChanged()
            .filter { $0 != self.sourceLanguageSegmentedControl.segmentCount - 1 }
            .bind(to: translateVM.sourceLanguageIndex)
            .disposed(by: disposeBag)

        targetLanguageSegmentedControl.rx.value
            .distinctUntilChanged()
            .filter { $0 != self.targetLanguageSegmentedControl.segmentCount - 1 }
            .bind(to: translateVM.targetLanguageIndex)
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
            .observeOn(MainScheduler.asyncInstance)
            .subscribe { [unowned self] _ in
                self.resizeAccordingToContent()
            }
            .disposed(by: disposeBag)
        translateVM.sourceLanguagesQueue
            .map { $0.map { $0?.fullName ?? "" }  }
            .bind(to: sourceLanguageSegmentedControl.rx.labels(for: 0..<sourceLanguageSegmentedControl.segmentCount - 1))
            .disposed(by: disposeBag)
        translateVM.targetLanguagesQueue
            .map { $0.map { $0?.fullName ?? "" } }
            .bind(to: targetLanguageSegmentedControl.rx.labels(for: 0..<targetLanguageSegmentedControl.segmentCount - 1))
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
