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

    let supportedLanguages = BehaviorRelay<SupportedLanguages?>(value: nil)
    let isSourceLanguagePickerActive = BehaviorRelay<Bool>(value: false)
    let sourceLanguageIndex = BehaviorRelay<Int>(value: 0)
    let isTargetLanguagePickerActive = BehaviorRelay<Bool>(value: false)
    let targetLanguageIndex = BehaviorRelay<Int>(value: 0)

    private let disposeBag = DisposeBag()
    private let targetLanguagesQueue = BehaviorRelay<FixedQueue<Language>>(value: FixedQueue<Language>(.russian, .english, .german))
    private let sourceLanguagesQueue = BehaviorRelay<FixedQueue<Language>>(value: FixedQueue<Language>(.english, .russian, .german))
    private let translateUseCase: TranslateUseCase
    private let dictionaryUseCase: DictionaryUseCase

    init(translateUseCase: TranslateUseCase, dictionaryUseCase: DictionaryUseCase) {
        self.translateUseCase = translateUseCase
        self.dictionaryUseCase = dictionaryUseCase

        translateUseCase
            .supportedLanguages()
            .bind(to: supportedLanguages)
            .disposed(by: disposeBag)
        setupPickersActivity()
    }
}

extension TranslateViewModel {
    private func setupPickersActivity() {
        isSourceLanguagePickerActive
            .subscribe { value in
                if value.element! && self.isTargetLanguagePickerActive.value {
                    self.isTargetLanguagePickerActive.accept(false)
                }
            }
            .disposed(by: disposeBag)
        isTargetLanguagePickerActive
            .subscribe { value in
                if value.element! && self.isSourceLanguagePickerActive.value {
                    self.isSourceLanguagePickerActive.accept(false)
                }
            }
            .disposed(by: disposeBag)
    }
}

extension TranslateViewModel: ViewModelType {
    struct TranslationDrivers {
        let inputText: Driver<String>
        let outputText: Driver<String>
        let limitationText: Driver<String>
        let clearButtonHidden: Driver<Bool>
    }

    struct PickerDrivers {
        let sourceLanguages: Driver<[LanguageProtocol]>
        let targetLanguages: Driver<[LanguageProtocol]>
        let supportedLanguages: Driver<[Language]>
    }

    struct Input {
        let inputText: Driver<String>
        let sourceLanguageIndex: Driver<Int>
        let targetLanguageIndex: Driver<Int>
        let clearButtonClicked: Driver<()>
        let languagePickerQuery: Driver<String>
        let languagePickerSelectedIndex: Driver<IndexPath>
    }

    struct Output {
        let translation: TranslationDrivers
        let picker: PickerDrivers
    }

    func transform(input: Input) -> Output {
        return Output(
            translation: translationDrivers(for: input),
            picker: pickerDrivers(for: input)
        )
    }
}

extension TranslateViewModel {
    private func translationDrivers(for input: Input) -> TranslationDrivers {
        let limitationText = input.inputText.map { "\($0.count)/\(self.maxTextCharactersCount)" }
        let clearButtonHidden = Driver.merge(
            input.clearButtonClicked.map { _ in true },
            input.inputText.map { $0.isEmpty }
        )
        let autoDetectionLanguageNeeded = input.sourceLanguageIndex.filter { $0 == 3 }.map { _ in () }
        let autoDetectedLanguage = Driver.merge(
            .just(AutoDetectedLanguage()),
            input.inputText.map { _ in AutoDetectedLanguage() },
            detectLanguage(for: autoDetectionLanguageNeeded.withLatestFrom(input.inputText))
        )
        let textTranslation = translation(
            source: input.sourceLanguageIndex,
            target: input.targetLanguageIndex,
            autoDetectedLanguage: autoDetectedLanguage,
            inputText: input.inputText
        )

        let outputText = Driver.merge(
            input.clearButtonClicked.map { _ in "" },
            input.inputText.map { _ in "" },
            textTranslation.map { $0.text ?? "" },
            Driver.merge(input.sourceLanguageIndex, input.targetLanguageIndex).map { _ in "" }
        )
        let inputText = input.clearButtonClicked.map { _ in "" }

        return TranslationDrivers(
            inputText: inputText,
            outputText: outputText,
            limitationText: limitationText,
            clearButtonHidden: clearButtonHidden
        )
    }

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

extension TranslateViewModel {
    private func pickerDrivers(for input: Input) -> PickerDrivers {
        let autoDetectionLanguageNeeded = input.sourceLanguageIndex.filter { $0 == 3 }.map { _ in () }
        let autoDetectedLanguage = Driver.merge(
            .just(AutoDetectedLanguage()),
            input.inputText.map { _ in AutoDetectedLanguage() },
            detectLanguage(for: autoDetectionLanguageNeeded.withLatestFrom(input.inputText))
        )

        let sourceLanguages: Driver<[LanguageProtocol]> = Driver.combineLatest(sourceLanguagesQueue.asDriver(), autoDetectedLanguage).map { $0.0.array + [$0.1] }
        let targetLanguages: Driver<[LanguageProtocol]> = targetLanguagesQueue.map { $0.array }.asDriver(onErrorJustReturn: [])

        let pickSupportedLanguages = Observable
            .combineLatest(Observable.merge(input.languagePickerQuery.asObservable(), Observable.just("")), supportedLanguages)
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .default))
            .map { q, supported -> [Language] in
                let languages = supported?.languages ?? []
                let query = q.lowercased()
                return query.isEmpty ? languages : languages.filter { $0.full?.lowercased().contains(query) ?? false }
            }
            .asDriver(onErrorJustReturn: [])

        let pickedLanguage = input.languagePickerSelectedIndex.debug()
            .withLatestFrom(pickSupportedLanguages) { index, languages in
                languages[index.item]
            }
        pickedLanguage.debug()
            .drive(onNext: { language in
                self.pick(language: language)
            })
            .disposed(by: disposeBag)
        return PickerDrivers(
            sourceLanguages: sourceLanguages,
            targetLanguages: targetLanguages,
            supportedLanguages: pickSupportedLanguages
        )
    }

    public func pick(language: Language) {
        if isSourceLanguagePickerActive.value {
            sourceLanguagesPush(language: language)
        } else if isTargetLanguagePickerActive.value {
            targetLanguagesPush(language: language)
        }
    }

    private func targetLanguagesPush(language: Language) {
        var queue = targetLanguagesQueue.value
        let (index, _) = queue.push(language)
        targetLanguageIndex.accept(index)
        targetLanguagesQueue.accept(queue)
        isTargetLanguagePickerActive.accept(false)
    }

    private func sourceLanguagesPush(language: Language) {
        var queue = sourceLanguagesQueue.value
        let (index, _) = queue.push(language)
        sourceLanguageIndex.accept(index)
        sourceLanguagesQueue.accept(queue)
        isSourceLanguagePickerActive.accept(false)
    }
}
