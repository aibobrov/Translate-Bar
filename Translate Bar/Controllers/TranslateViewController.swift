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
	@IBOutlet weak var textContentStackView: NSStackView!
	@IBOutlet weak var pickerContentView: View!
	@IBOutlet weak var contentView: NSView!
	@IBOutlet weak var mainScrollView: NSScrollView!
	@IBOutlet weak var inputTextView: LimitedTextView!
	@IBOutlet weak var outputTextView: NSTextView!

	@IBOutlet weak var inputTextViewLimitationLabel: NSTextField!
	@IBOutlet weak var clearButton: NSButton!
	@IBOutlet weak var suggestTextLabel: NSTextField!
	@IBOutlet weak var pickerContainerHeightConstraint: NSLayoutConstraint!
	@IBOutlet weak var textContainerHeightConstraint: NSLayoutConstraint!

	@IBOutlet weak var sourceLanguageSegmentedControl: SegmentedControl!
	@IBOutlet weak var targetLanguageSegmentedControl: SegmentedControl!
	@IBOutlet weak var swapButton: NSButton!
	@IBOutlet weak var languagesCollectionView: NSCollectionView!
	@IBOutlet weak var searchTextField: NSTextField!

	@IBOutlet weak var refreshButton: NSButton!
	@IBOutlet weak var settingsButton: NSButton!
    @IBOutlet weak var pinButton: NSButton!

	let languageCollectionViewManager: LanguageCollectionViewManager = {
		let manager = LanguageCollectionViewManager(identifier: "LanguageCollectionViewItem", items: []) { (language, _, cell) in
			cell.imageView!.image = NSImage(named: NSImage.Name(rawValue: language.shortName))
			cell.textField!.stringValue = language.fullName!
		}
		return manager
	}()

	let translateVM = TranslateViewModel()
	private let disposeBag = DisposeBag()

	override func viewDidLoad() {
		super.viewDidLoad()
		inputTextView.maxCharactersCount = translateVM.maxCharactersCount
		sourceLanguageSegmentedControl.singleSelectionSegments = (0..<sourceLanguageSegmentedControl.segmentCount - 1).map { $0 }
		targetLanguageSegmentedControl.singleSelectionSegments = (0..<targetLanguageSegmentedControl.segmentCount - 1).map { $0 }

		setupUIBindings()
		setupViewModelBindings()

		setupCollecionView()
	}

	override func viewDidAppear() {
		super.viewDidAppear()
		NSApplication.shared.activate(ignoringOtherApps: true)

		let appDelegate = NSApplication.shared.delegate as! AppDelegate // swiftlint:disable:this force_cast
		let popoverWindow = appDelegate.popover.contentViewController!.view.window!
		popoverWindow.parent?.removeChildWindow(popoverWindow)
	}

	private func setupCollecionView() {
		languagesCollectionView.dataSource = languageCollectionViewManager
		languagesCollectionView.delegate = languageCollectionViewManager

		languageCollectionViewManager.rx
			.selectedItem
			.subscribe(onNext: { (language, _, _) in
				self.translateVM.pick(language: language)
			})
			.disposed(by: disposeBag)

		translateVM.allLanguages
			.observeOn(MainScheduler.asyncInstance)
			.bind(to: languagesCollectionView.rx.data(dataSourceType: CollectionViewManager<[Language], LanguageCollectionViewItem>.self))
			.disposed(by: disposeBag)
	}

	private func setupUIBindings() {
		setupTextBindings()

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

		translateVM.targetLanguageIndex
			.bind(to: targetLanguageSegmentedControl.rx.selectSegment)
			.disposed(by: disposeBag)
		translateVM.sourceLanguageIndex
			.bind(to: sourceLanguageSegmentedControl.rx.selectSegment)
			.disposed(by: disposeBag)

		swapButton.rx
			.controlEvent
			.subscribe { _ in
				self.translateVM.swap()
			}
			.disposed(by: disposeBag)

		setupPickerBehaviour()
		setupBottomBar()
	}

	private func setupBottomBar() {
		refreshButton.rx
			.controlEvent
			.subscribe { _ in
				self.resizeAccordingToContent()
			}
			.disposed(by: disposeBag)
        pinButton.rx
            .state
            .map { $0 == .on }
            .bind(to: translateVM.isPopoverPinned)
            .disposed(by: disposeBag)

        settingsButton.rx.controlEvent.subscribe(onNext: { _ in
            self.showSettings()
        })
        .disposed(by: disposeBag)
	}

	private func setupTextBindings() {
		inputTextView.rx.text
			.bind(to: translateVM.rawInput)
			.disposed(by: disposeBag)

		translateVM.rawInput
			.bind(to: inputTextView.rx.text)
			.disposed(by: disposeBag)

		translateVM.rawOutput
			.bind(to: outputTextView.rx.text)
			.disposed(by: disposeBag)

		inputTextView.rx.words
			.bind(to: translateVM.inputWords)
			.disposed(by: disposeBag)

		clearButton.rx.controlEvent
			.map { "" }
			.bind(to: translateVM.rawInput)
			.disposed(by: disposeBag)
	}

	private func setupPickerBehaviour() {
		searchTextField.rx
			.text
			.bind(to: translateVM.searchQueryString)
			.disposed(by: disposeBag)

		sourceLanguageSegmentedControl.rx
			.isSelected(for: sourceLanguageSegmentedControl.segmentCount - 1)
			.bind(to: translateVM.isSourceLanguagePickerActive)
			.disposed(by: disposeBag)
		targetLanguageSegmentedControl.rx
			.isSelected(for: targetLanguageSegmentedControl.segmentCount - 1)
			.bind(to: translateVM.isTargetLanguagePickerActive)
			.disposed(by: disposeBag)
		translateVM.isTargetLanguagePickerActive
			.bind(to: targetLanguageSegmentedControl.rx
				.isSelected(for: targetLanguageSegmentedControl.segmentCount - 1)
			)
			.disposed(by: disposeBag)
		translateVM.isSourceLanguagePickerActive
			.bind(to: sourceLanguageSegmentedControl.rx
				.isSelected(for: targetLanguageSegmentedControl.segmentCount - 1)
			)
			.disposed(by: disposeBag)
	}

	private func setupViewModelBindings() {
		translateVM.clearButtonHidden
			.bind(to: self.clearButton.rx.isHidden)
			.disposed(by: disposeBag)

		translateVM.isSuggestHidden
			.bind(to: self.suggestTextLabel.rx.isHidden)
			.disposed(by: disposeBag)

		translateVM.limitationText
			.bind(to: self.inputTextViewLimitationLabel.rx.text)
			.disposed(by: disposeBag)

		translateVM.text
			.observeOn(MainScheduler.asyncInstance)
			.subscribe { _ in
				self.resizeAccordingToContent()
			}
			.disposed(by: disposeBag)
		translateVM.sourceLanguagesQueue
			.map { $0.map { $0.fullName ?? "" }  }
			.bind(to: sourceLanguageSegmentedControl.rx.labels(for: 0..<sourceLanguageSegmentedControl.segmentCount - 1))
			.disposed(by: disposeBag)
		translateVM.targetLanguagesQueue
			.map { $0.map { $0.fullName ?? "" } }
			.bind(to: targetLanguageSegmentedControl.rx.labels(for: 0..<targetLanguageSegmentedControl.segmentCount - 1))
			.disposed(by: disposeBag)

		translateVM.isLanguagePickerNeeded
			.map { !$0 }
			.bind(to: pickerContentView.rx.isHidden)
			.disposed(by: disposeBag)
		translateVM.isLanguagePickerNeeded
			.bind(to: textContentStackView.rx.isHidden)
			.disposed(by: disposeBag)
		translateVM.isLanguagePickerNeeded
			.observeOn(MainScheduler.asyncInstance)
			.subscribe { _ in
				self.resizeAccordingToContent()
			}
			.disposed(by: disposeBag)
	}

    private func showSettings() {
        let appDelegate = NSApplication.shared.delegate as! AppDelegate // swiftlint:disable:this force_cast
        appDelegate.popover.contentViewController = appDelegate.settingsViewController
    }

	private func resizeAccordingToContent() {
		view.layoutSubtreeIfNeeded()

		if !textContentStackView.isHidden {
			resizeAccordingToTextContent()
		} else if !pickerContentView.isHidden {
			resizeAccordingToPickerContent()
		}

		view.layoutSubtreeIfNeeded()
		let appDelegate = NSApplication.shared.delegate as! AppDelegate // swiftlint:disable:this force_cast
		appDelegate.popover.contentSize.height = self.contentView.frame.height
	}

	private func resizeAccordingToTextContent() {
		let maxExtraSpace = textContentStackView.frame.height + inputTextViewLimitationLabel.frame.height - min(self.inputTextView.frame.height, self.outputTextView.frame.height)
		let maxTextContentHeight = max(self.inputTextView.intrinsicContentSize.height, self.outputTextView.intrinsicContentSize.height)

		let maxTextContainerHeight = maxTextContentHeight + maxExtraSpace
		textContainerHeightConstraint.constant = max(200, maxTextContainerHeight)
	}

	private func resizeAccordingToPickerContent() {
		let languageViewHeight = languagesCollectionView.enclosingScrollView?.frame.height ?? 0
		let extraSpace = pickerContainerHeightConstraint.constant - languageViewHeight
		let contentHeight = languagesCollectionView.collectionViewLayout?.collectionViewContentSize.height ?? 0
		let pickerContainerHeight = contentHeight + extraSpace
		pickerContainerHeightConstraint.constant = max(200, pickerContainerHeight)
	}
}
