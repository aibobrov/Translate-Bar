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
    @IBOutlet private var appView: AppView!

    weak var coordinator: AppCoordinator?

    private let disposeBag = DisposeBag()
    private let viewModel = TranslateViewModel(translateUseCase: TranslateProvider(), dictionaryUseCase: DictionaryProvider())

    convenience init(coordinator: AppCoordinator) {
        self.init()
        self.coordinator = coordinator
    }

    override func loadView() {
        super.loadView()
        let sourceSegmentCount = appView.topBar.sourceLanguageSegmentedControl.segmentCount
        let targetSegmentCount = appView.topBar.targetLanguageSegmentedControl.segmentCount
        appView.topBar.sourceLanguageSegmentedControl.singleSelectionSegments = (0 ..< sourceSegmentCount - 1).map { $0 }
        appView.topBar.targetLanguageSegmentedControl.singleSelectionSegments = (0 ..< targetSegmentCount - 1).map { $0 }
        appView.translationView.input.textView.maxCharactersCount = viewModel.maxTextCharactersCount

        appView.translationView.input.textView.font = FontFamily.Roboto.regular.font(size: 13)
        appView.translationView.output.translationText.textView.font = FontFamily.Roboto.regular.font(size: 13)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        createBindings()
        apply(viewModel.transform(input: input()))
        appView.bottomBar.reloadButton.rx.tap.subscribe { _ in
            self.appView.invalidateIntrinsicContentSize()
            self.appView.layoutSubtreeIfNeeded()
        }.disposed(by: disposeBag)
    }

    private func input() -> TranslateViewModel.Input {
        let languagePickerQuery = appView.languagePick.searchTextField.rx.text.orEmpty
        let languagePickerSelectedIndex = appView.languagePick.contentCollectionView.rx.itemSelected.asDriverOnErrorJustComplete()

        return TranslateViewModel.Input(
            clearButtonClicked: appView.translationView.input.closeButton.rx.controlEvent.asDriver(),
            swapButtonClicked: appView.topBar.swapButton.rx.controlEvent.asDriver(),
            languagePickerQuery: languagePickerQuery.asDriver(),
            languagePickerSelectedIndex: languagePickerSelectedIndex
        )
    }

    private func createBindings() {
        let sourceLanguageIndex = appView.sourceLanguageIndex
        let targetLanguageIndex = appView.targetLanguageIndex
        let sourceLanguagePickerNeeded = appView.sourceLanguagePickerNeeded
        let targetLanguagePickerNeeded = appView.targetLanguagePickerNeeded

        (sourceLanguagePickerNeeded <-> viewModel.isSourceLanguagePickerActive).disposed(by: disposeBag)
        (targetLanguagePickerNeeded <-> viewModel.isTargetLanguagePickerActive).disposed(by: disposeBag)

        sourceLanguageIndex.bind(to: viewModel.sourceLanguageIndex).disposed(by: disposeBag)
        targetLanguageIndex.bind(to: viewModel.targetLanguageIndex).disposed(by: disposeBag)
        viewModel.targetLanguageIndex.bind(to: appView.topBar.targetLanguageSegmentedControl.rx.selectSegment).disposed(by: disposeBag)
        viewModel.sourceLanguageIndex.bind(to: appView.topBar.sourceLanguageSegmentedControl.rx.selectSegment).disposed(by: disposeBag)

        viewModel.isPickerNeeded.map { !$0 }.drive(appView.languagePick.rx.isHidden).disposed(by: disposeBag)
        viewModel.isPickerNeeded.drive(appView.translationView.rx.isHidden).disposed(by: disposeBag)

        (appView.translationView.input.textView.rx.text.orEmpty <-> viewModel.inputText).disposed(by: disposeBag)
        (appView.translationView.output.translationText.textView.rx.text.orEmpty <-> viewModel.outputText).disposed(by: disposeBag)
        viewModel.outputText.map { $0.isEmpty }.distinctUntilChanged()
            .bind(to: appView.translationView.output.rx.isHidden).disposed(by: disposeBag)
    }
}

extension TranslateViewController {
    private func apply(_ output: TranslateViewModel.Output) {
        apply(translationDrivers: output.translation)
        apply(pickerDrivers: output.picker)
    }

    private func apply(translationDrivers translation: TranslateViewModel.TranslationDrivers) {
        translation.limitationText
            .drive(appView.translationView.input.contentLengthField.rx.text)
            .disposed(by: disposeBag)
        translation.clearButtonHidden
            .drive(appView.translationView.input.closeButton.rx.isHidden)
            .disposed(by: disposeBag)
        let article = translation.dictionaryArticle
        article.map { $0.isEmpty }.drive(appView.translationView.output.translationArticle.rx.isHidden).disposed(by: disposeBag)
        article.drive(appView.translationView.output.translationArticle.contentTableView.rx.items) { _, tv, _, article in
            let view = tv.makeView(ofType: DictionaryArticleCellView.self)
            view.configure(with: article)
            return view
        }
        .disposed(by: disposeBag)
    }

    private func apply(pickerDrivers picker: TranslateViewModel.PickerDrivers) {
        picker.sourceLanguages.map { $0.map { $0.description } }
            .drive(appView.topBar.sourceLanguageSegmentedControl.rx.labels(for: 0 ..< 4))
            .disposed(by: disposeBag)
        picker.targetLanguages.map { $0.map { $0.description } }
            .drive(appView.topBar.targetLanguageSegmentedControl.rx.labels(for: 0 ..< 3))
            .disposed(by: disposeBag)

        picker.supportedLanguages
            .drive(appView.languagePick.contentCollectionView.rx.items) { _, cv, ip, language in
                let item = cv.makeItem(ofType: LanguageCollectionViewItem.self, for: ip)
                item.configure(with: language)
                return item
            }
            .disposed(by: disposeBag)
    }
}
