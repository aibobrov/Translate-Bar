//
//  TranslateViewController.swift
//  TranslateBar
//
//  Created by Artem Bobrov on 21/10/2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa
import RxSwift

class TranslateViewController: NSViewController {
    @IBOutlet var topBar: TopBar!
    @IBOutlet var bottomBar: BottomBar!
    @IBOutlet var languagePick: LanguageSearch!
    @IBOutlet var translationView: TranslationView!

    weak var coordinator: AppCoordinator?

    private let disposeBag = DisposeBag()
    private let viewModel = TranslateViewModel(translateUseCase: TranslateProvider(), dictionaryUseCase: DictionaryProvider())

    convenience init(coordinator: AppCoordinator) {
        self.init()
        self.coordinator = coordinator
    }

    override func loadView() {
        super.loadView()
        let sourceSegmentCount = topBar.sourceLanguageSegmentedControl.segmentCount
        let targetSegmentCount = topBar.targetLanguageSegmentedControl.segmentCount
        topBar.sourceLanguageSegmentedControl.singleSelectionSegments = (0 ..< sourceSegmentCount - 1).map { $0 }
        topBar.targetLanguageSegmentedControl.singleSelectionSegments = (0 ..< targetSegmentCount - 1).map { $0 }
        translationView.input.textView.maxCharactersCount = viewModel.maxTextCharactersCount

        translationView.input.textView.font = FontFamily.Roboto.regular.font(size: 13)
        translationView.output.textView.font = FontFamily.Roboto.regular.font(size: 13)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let input = self.input()
        let output = viewModel.transform(input: input)
        apply(output)
    }

    private func input() -> TranslateViewModel.Input {
        let inputText = translationView.input.textView.rx.text.orEmpty
            .throttle(1, latest: true, scheduler: MainScheduler.asyncInstance)

        let sourceLanguageIndex = topBar.sourceLanguageSegmentedControl.rx.selectedSegmentIndex.distinctUntilChanged()
            .filter { $0 != self.topBar.sourceLanguageSegmentedControl.segmentCount - 1 }
        let targetLanguageIndex = topBar.targetLanguageSegmentedControl.rx.selectedSegmentIndex.distinctUntilChanged()
            .filter { $0 != self.topBar.targetLanguageSegmentedControl.segmentCount - 1 }
        let languagePickerQuery = languagePick.searchTextField.rx.text.orEmpty
        let languagePickerSelectedIndex = languagePick.contentCollectionView.rx.itemSelected.asDriverOnErrorJustComplete()
        let sourceLanguagePickerNeeded = topBar.sourceLanguageSegmentedControl.rx.isSelected(with: topBar.sourceLanguageSegmentedControl.segmentCount - 1)
        let targetLanguagePickerNeeded = topBar.targetLanguageSegmentedControl.rx.isSelected(with: topBar.targetLanguageSegmentedControl.segmentCount - 1)
        (sourceLanguagePickerNeeded <-> viewModel.isSourceLanguagePickerActive).disposed(by: disposeBag)
        (targetLanguagePickerNeeded <-> viewModel.isTargetLanguagePickerActive).disposed(by: disposeBag)

        sourceLanguageIndex.bind(to: viewModel.sourceLanguageIndex).disposed(by: disposeBag)
        targetLanguageIndex.bind(to: viewModel.targetLanguageIndex).disposed(by: disposeBag)
        viewModel.targetLanguageIndex.bind(to: topBar.targetLanguageSegmentedControl.rx.selectSegment).disposed(by: disposeBag)
        viewModel.sourceLanguageIndex.bind(to: topBar.sourceLanguageSegmentedControl.rx.selectSegment).disposed(by: disposeBag)

        return TranslateViewModel.Input(
            inputText: inputText.asDriver(onErrorJustReturn: ""),
            sourceLanguageIndex: sourceLanguageIndex.asDriver(onErrorJustReturn: 0),
            targetLanguageIndex: targetLanguageIndex.asDriver(onErrorJustReturn: 0),
            clearButtonClicked: translationView.input.closeButton.rx.controlEvent.asDriver(),
            languagePickerQuery: languagePickerQuery.asDriver(),
            languagePickerSelectedIndex: languagePickerSelectedIndex
        )
    }
}

extension TranslateViewController {
    private func apply(_ output: TranslateViewModel.Output) {
        apply(translationDrivers: output.translation)
        apply(pickerDrivers: output.picker)
    }

    private func apply(translationDrivers translation: TranslateViewModel.TranslationDrivers) {
        translation.inputText.drive(translationView.input.textView.rx.text).disposed(by: disposeBag)
        translation.outputText.drive(translationView.output.textView.rx.text).disposed(by: disposeBag)
        translation.limitationText.asObservable()
            .bind(to: translationView.input.contentLengthField.rx.text)
            .disposed(by: disposeBag)
        translation.clearButtonHidden.asObservable()
            .bind(to: translationView.input.closeButton.rx.isHidden)
            .disposed(by: disposeBag)
    }

    private func apply(pickerDrivers picker: TranslateViewModel.PickerDrivers) {
        picker.sourceLanguages.map { $0.map { $0.description } }.asObservable()
            .bind(to: topBar.sourceLanguageSegmentedControl.rx.labels(for: 0 ..< 4))
            .disposed(by: disposeBag)
        picker.targetLanguages.map { $0.map { $0.description } }.asObservable()
            .bind(to: topBar.targetLanguageSegmentedControl.rx.labels(for: 0 ..< 3))
            .disposed(by: disposeBag)

        picker.supportedLanguages.asObservable()
            .bind(to: languagePick.contentCollectionView.rx.items) { _, cv, ip, language in
                let item = cv.makeItem(withIdentifier: NSUserInterfaceItemIdentifier("LanguageCollectionViewItem"), for: ip) as! LanguageCollectionViewItem // swiftlint:disable:this force_cast
                item.imageView!.image = NSImage(named: language.imageName)
                item.textField!.stringValue = language.description
                return item
            }
            .disposed(by: disposeBag)
    }
}
