//
//  TranslateViewModel.swift
//  TranslateBar
//
//  Created by Artem Bobrov on 28/10/2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import RxCocoa
import RxSwift

final class TranslateViewModel {
    let maxTextCharactersCount = 5000

    private let targetLanguagesQueue = BehaviorRelay<FixedQueue<Language>>(value: FixedQueue<Language>(.russian, .english, .german))
    private let sourceLanguagesQueue = BehaviorRelay<FixedQueue<Language>>(value: FixedQueue<Language>(.english, .russian, .german))
    private let translateUseCase: TranslateUseCase
    private let dictionaryUseCase: DictionaryUseCase

    init(translateUseCase: TranslateUseCase, dictionaryUseCase: DictionaryUseCase) {
        self.translateUseCase = translateUseCase
        self.dictionaryUseCase = dictionaryUseCase
    }
}

extension TranslateViewModel: ViewModelType {
    struct Input {
        let inputText: Driver<String>
        let sourceLanguageIndex: Driver<Int>
        let targetLanguageIndex: Driver<Int>
        let autoDetectionLanguageNeeded: Driver<()>
        let clearButtonClicked: Driver<()>
    }

    struct Output {
        let inputText: Driver<String>
        let outputText: Driver<String>
        let limitationText: Driver<String>
        let clearButtonHidden: Driver<Bool>
        let sourceLanguages: Driver<[LanguageProtocol]>
        let targetLanguages: Driver<[LanguageProtocol]>
    }

    func transform(input: Input) -> Output {
        let limitationText = input.inputText.map { "\($0.count)/\(self.maxTextCharactersCount)" }
        let clearButtonHidden = Driver.merge(
            input.clearButtonClicked.map { _ in true },
            input.inputText.map { $0.isEmpty }
        )
        let autoDetectedLanguage = Driver.merge(
            .just(AutoDetectedLanguage()),
            input.inputText.map { _ in AutoDetectedLanguage() },
            detectLanguage(for: input.autoDetectionLanguageNeeded.withLatestFrom(input.inputText))
        )
        let textTranslation = translation(
            source: input.sourceLanguageIndex,
            target: input.targetLanguageIndex,
            autoDetectedLanguage: autoDetectedLanguage,
            inputText: input.inputText
        )
        let sourceLanguages: Driver<[LanguageProtocol]> = Driver.combineLatest(sourceLanguagesQueue.asDriver(), autoDetectedLanguage).map { $0.0.array + [$0.1] }
        let targetLanguages: Driver<[LanguageProtocol]> = targetLanguagesQueue.map { $0.array }.asDriver(onErrorJustReturn: [])

        let outputText = Driver.merge(
            input.clearButtonClicked.map { _ in "" },
            input.inputText.map { _ in "" },
            textTranslation.map { $0.text ?? "" },
            Driver.merge(input.sourceLanguageIndex, input.targetLanguageIndex).map { _ in "" }
        )
        let inputText = input.clearButtonClicked.map { _ in "" }
        return Output(
            inputText: inputText,
            outputText: outputText,
            limitationText: limitationText,
            clearButtonHidden: clearButtonHidden,
            sourceLanguages: sourceLanguages,
            targetLanguages: targetLanguages
        )
    }
}

extension TranslateViewModel {
    private func translation(source sourceLanguageIndex: Driver<Int>, target targetLanguageIndex: Driver<Int>, autoDetectedLanguage: Driver<AutoDetectedLanguage>, inputText: Driver<String>) -> Driver<Translation> {
        let sourceLanguage = Driver.combineLatest(sourceLanguageIndex, autoDetectedLanguage, sourceLanguagesQueue.asDriver())
            .map { 0 ..< self.sourceLanguagesQueue.value.count ~= $0.0 ? self.sourceLanguagesQueue.value[$0.0] as LanguageProtocol : $0.1 as LanguageProtocol }
            .distinctUntilChanged { $0.short == $1.short }
        let targetLanguage = Driver.combineLatest(targetLanguageIndex, targetLanguagesQueue.asDriver())
            .map { self.targetLanguagesQueue.value[$0.0] as LanguageProtocol }

        return Driver.combineLatest(inputText, sourceLanguage, targetLanguage)
            .flatMapLatest { text, source, target in
                self.translateUseCase.translate(from: source, to: target, text: text).asDriverOnErrorJustComplete()
            }
    }

    private func detectLanguage(for text: Driver<String>) -> Driver<AutoDetectedLanguage> {
        return text
            .flatMapLatest { self.translateUseCase.detectLanguage(text: $0).asDriverOnErrorJustComplete() }
            .map { AutoDetectedLanguage(real: $0) }
    }
}
