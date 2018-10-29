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
        apply(output: output)
    }

    private func input() -> TranslateViewModel.Input {
        let inputText = translationView.input.textView.rx
            .text
            .orEmpty
            .throttle(1, latest: true, scheduler: MainScheduler.asyncInstance)

        let sourceLanguageIndex = topBar.sourceLanguageSegmentedControl.rx
            .selectedSegmentIndex
            .distinctUntilChanged()
            .filter { $0 != self.topBar.sourceLanguageSegmentedControl.segmentCount - 1 }
        let targetLanguageIndex = topBar.targetLanguageSegmentedControl.rx
            .selectedSegmentIndex
            .distinctUntilChanged()
            .filter { $0 != self.topBar.targetLanguageSegmentedControl.segmentCount - 1 }
        let autoDetectionLanguageNeeded = topBar.sourceLanguageSegmentedControl.rx
            .selectedSegmentIndex.filter { $0 == self.topBar.sourceLanguageSegmentedControl.segmentCount - 2 }.mapTo(())

        let input = TranslateViewModel.Input(
            inputText: inputText.asDriver(onErrorJustReturn: ""),
            sourceLanguageIndex: sourceLanguageIndex.asDriver(onErrorJustReturn: 0),
            targetLanguageIndex: targetLanguageIndex.asDriver(onErrorJustReturn: 0),
            autoDetectionLanguageNeeded: autoDetectionLanguageNeeded.asDriver(onErrorJustReturn: ()),
            clearButtonClicked: translationView.input.closeButton.rx.controlEvent.asDriver()
        )
        return input
    }

    private func apply(output: TranslateViewModel.Output) {
        output.inputText.drive(translationView.input.textView.rx.text).disposed(by: disposeBag)
        output.outputText.drive(translationView.output.textView.rx.text).disposed(by: disposeBag)
        output.limitationText.asObservable()
            .bind(to: translationView.input.contentLengthField.rx.text)
            .disposed(by: disposeBag)
        output.clearButtonHidden.asObservable()
            .bind(to: translationView.input.closeButton.rx.isHidden)
            .disposed(by: disposeBag)

        output.sourceLanguages
            .map { $0.map { $0.description } }
            .asObservable()
            .bind(to: topBar.sourceLanguageSegmentedControl.rx.labels(for: 0 ..< 4))
            .disposed(by: disposeBag)
        output.targetLanguages
            .map { $0.map { $0.description } }
            .asObservable()
            .bind(to: topBar.targetLanguageSegmentedControl.rx.labels(for: 0 ..< 3))
            .disposed(by: disposeBag)
    }
}
