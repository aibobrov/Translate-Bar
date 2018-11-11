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

    let inputText = BehaviorRelay<String>(value: "")
    let outputText = BehaviorRelay<String>(value: "")

    let isSourceLanguagePickerActive = BehaviorRelay<Bool>(value: false)
    let isTargetLanguagePickerActive = BehaviorRelay<Bool>(value: false)

    let sourceLanguageIndex = BehaviorRelay<Int>(value: 0)
    let targetLanguageIndex = BehaviorRelay<Int>(value: 0)

    private let disposeBag = DisposeBag()
    private let targetLanguagesQueue = BehaviorRelay<FixedQueue<Language>>(value: FixedQueue<Language>(.russian, .english, .german))
    private let sourceLanguagesQueue = BehaviorRelay<FixedQueue<Language>>(value: FixedQueue<Language>(.english, .russian, .german))
    private let translateUseCase: TranslateUseCase
    private let dictionaryUseCase: DictionaryUseCase
    private let spellerUseCase: SpellerUseCase

    init(translateUseCase: TranslateUseCase,
         dictionaryUseCase: DictionaryUseCase,
         spellerUseCase: SpellerUseCase) {
        self.translateUseCase = translateUseCase
        self.dictionaryUseCase = dictionaryUseCase
        self.spellerUseCase = spellerUseCase

        translateUseCase
            .supportedLanguages()
            .bind(to: supportedLanguages)
            .disposed(by: disposeBag)
        setupPickersActivity()
        NotificationCenter.default.rx
            .notification(.linkClicked)
            .map { $0.object as! OnLinkActionQuery }
            .subscribe(onNext: { [unowned self] query in
                if query.action == .swap {
                    rx_swap(self.inputText, self.outputText)
                    self.swapLanguages()
                }
                self.inputText.accept(query.query)
            })
            .disposed(by: disposeBag)
    }

    var isPickerNeeded: Driver<Bool> {
        return Driver
            .merge(isSourceLanguagePickerActive.asDriver(), isTargetLanguagePickerActive.asDriver())
            .distinctUntilChanged()
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
        let limitationText: Driver<String>
        let clearButtonHidden: Driver<Bool>
        let dictionaryArticle: Driver<[DictionaryArticle]>
        let suggestionText: Driver<NSAttributedString>
    }

    struct PickerDrivers {
        let sourceLanguages: Driver<[LanguageProtocol]>
        let targetLanguages: Driver<[LanguageProtocol]>
        let supportedLanguages: Driver<[Language]>
    }

    struct Input {
        let clearButtonClicked: Driver<()>
        let swapButtonClicked: Driver<()>
        let languagePickerQuery: Driver<String>
        let languagePickerSelectedIndex: Driver<IndexPath>
        let suggenstionLinkClicked: Driver<String>
		let translationFromClipboardNeeded: Driver<Void>
    }

    struct Output {
        let translation: TranslationDrivers
        let picker: PickerDrivers
    }

    func transform(input: Input) -> Output {
        return Output(translation: translationDrivers(for: input),
                      picker: pickerDrivers(for: input))
    }
}

extension TranslateViewModel {
    private func translationDrivers(for input: Input) -> TranslationDrivers {
        let inputTextDriver = inputText.asDriver()
        let sourceLanguageIndexDriver = sourceLanguageIndex.asDriver()
        let targetLanguageIndexDriver = targetLanguageIndex.asDriver()

        let limitationText = inputTextDriver.map { "\($0.count)/\(self.maxTextCharactersCount)" }
        let clearButtonHidden = Driver.merge(input.clearButtonClicked.map { _ in true },
                                             inputTextDriver.map { $0.isEmpty })
		input.translationFromClipboardNeeded
			.filter { Settings.shared.isAutomaticallyTranslateClipboard }
			.map { NSPasteboard.clipboard ?? "" }
			.drive(inputText)
			.disposed(by: disposeBag)
        let autoDetectedLanguage = self.autoDetectedLanguage()
        input.suggenstionLinkClicked
            .map { text in
                let result = text.split(separator: TranslateClickAction.separator).map(String.init)
                let action = TranslateClickAction(rawValue: result.last!)!
                let query = String(result.dropLast().joined())
                return OnLinkActionQuery(action: action, query: query)
            }

            .drive(onNext: { object in
                NotificationCenter.default.post(name: .linkClicked, object: object)
            })
            .disposed(by: disposeBag)
        let textTranslation = translation(source: sourceLanguageIndexDriver,
                                          target: targetLanguageIndexDriver,
                                          autoDetectedLanguage: autoDetectedLanguage,
                                          inputText: inputTextDriver.throttle(1))
        let languageChanged = Driver.merge(sourceLanguageIndexDriver, targetLanguageIndexDriver)
        Driver.merge(input.clearButtonClicked.map { _ in "" },
                     inputTextDriver.filter { $0.isEmpty },
                     textTranslation.map { $0.text ?? "" },
                     languageChanged.map { _ in "" })
            .drive(outputText).disposed(by: disposeBag)
        input.clearButtonClicked.map { _ in "" }.drive(inputText).disposed(by: disposeBag)

        input.swapButtonClicked
            .withLatestFrom(sourceLanguageIndex.asDriver().map { $0 == 3 })
            .do(onNext: { _ in
                rx_swap(self.inputText, self.outputText)
            })
            .filter { !$0 }.map { _ in () }
            .drive(onNext: swapLanguages)
            .disposed(by: disposeBag)

        let sourceLanguage = Driver.combineLatest(sourceLanguageIndex.asDriver(), autoDetectedLanguage.asDriver(), sourceLanguagesQueue.asDriver())
            .map { 0 ..< self.sourceLanguagesQueue.value.count ~= $0.0 ? self.sourceLanguagesQueue.value[$0.0] as LanguageProtocol : $0.1 as LanguageProtocol }
            .distinctUntilChanged { $0.short == $1.short }

        let mistakes = Driver.combineLatest(inputTextDriver.throttle(1.5), sourceLanguage).filter { $0.0.count <= 60 }.flatMapLatest { text, language in
            return self.spellerUseCase.mistakes(for: text, language: language).asDriver(onErrorJustReturn: [])
        }
        let suggestion = mistakes.filter { !$0.isEmpty }
            .withLatestFrom(inputTextDriver) { (mistakes: [SpellMistake], text: String) -> String in
                var string = text
                for mistake in mistakes.reversed() {
                    guard let suggestion = mistake.values.first else { continue }
                    let start = string.index(string.startIndex, offsetBy: mistake.position)
                    let end = string.index(start, offsetBy: mistake.length)
                    string.replaceSubrange(start ..< end, with: suggestion)
                }
                return string
            }
            .map { NSAttributedString(string: $0).applying(.link("\($0)\(TranslateClickAction.separator)\(TranslateClickAction.keep.rawValue)")) }
            .map { NSAttributedString(string: "Did you mean ") + $0 + NSAttributedString(string: "?") }
        let suggestionAttributedString = Driver.merge(inputTextDriver.map { _ in NSAttributedString(string: "") }, suggestion)
        return TranslationDrivers(limitationText: limitationText,
                                  clearButtonHidden: clearButtonHidden,
                                  dictionaryArticle: article(autoDetectedLanguage: autoDetectedLanguage),
                                  suggestionText: suggestionAttributedString)
    }

    private func suggestionsAttributedText(_ value: ([SpellMistake], String)) -> String {
        var string = value.1
        for mistake in value.0 {
            guard let suggestion = mistake.values.first else { continue }
            let start = string.index(string.startIndex, offsetBy: mistake.position)
            let end = string.index(start, offsetBy: mistake.length)
            string.replaceSubrange(start ..< end, with: suggestion)
        }
        return string
    }

    private func article(autoDetectedLanguage: Driver<AutoDetectedLanguage>) -> Driver<[DictionaryArticle]> {
        let words = inputText.asDriver().map { $0.words }
        let word = words.filter { $0.count == 1 }.map { $0.first! }
        return Driver.merge(
            inputText.asDriver().map { _ in [] },
            dictionaryArticle(source: sourceLanguageIndex.asDriver(),
                              target: targetLanguageIndex.asDriver(),
                              autoDetectedLanguage: autoDetectedLanguage,
                              word: word.debounce(0.5))
        )
    }

    private func dictionaryArticle(source sourceLanguageIndex: Driver<Int>, target targetLanguageIndex: Driver<Int>, autoDetectedLanguage: Driver<AutoDetectedLanguage>, word: Driver<String>) -> Driver<[DictionaryArticle]> {
        let sourceLanguage = Driver.combineLatest(sourceLanguageIndex, autoDetectedLanguage, sourceLanguagesQueue.asDriver())
            .map { 0 ..< self.sourceLanguagesQueue.value.count ~= $0.0 ? self.sourceLanguagesQueue.value[$0.0] as LanguageProtocol : $0.1 as LanguageProtocol }
            .distinctUntilChanged { $0.short == $1.short }
        let targetLanguage = Driver.combineLatest(targetLanguageIndex, targetLanguagesQueue.asDriver())
            .map { self.targetLanguagesQueue.value[$0.0] as LanguageProtocol }
        return Driver.combineLatest(word, sourceLanguage, targetLanguage)
            .flatMapLatest { word, source, target in
                self.dictionaryUseCase.lookup(from: source, to: target, text: word).asDriver(onErrorJustReturn: [])
            }
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

    private func autoDetectedLanguage() -> Driver<AutoDetectedLanguage> {
        let autoDetectionLanguageNeeded = sourceLanguageIndex.asDriver().map { $0 == 3 }
        let autoDetectedText = Driver.combineLatest(autoDetectionLanguageNeeded, inputText.asDriver().throttle(1)).filter { $0.0 }.map { $0.1 }
        let clearDetectedLanguage = autoDetectionLanguageNeeded.distinctUntilChanged().filter { !$0 }
        let autoDetectedLanguage = Driver.merge(.just(AutoDetectedLanguage()),
                                                clearDetectedLanguage.map { _ in AutoDetectedLanguage() },
                                                detectLanguage(for: autoDetectedText))
        return autoDetectedLanguage
    }
}

extension TranslateViewModel {
    private func pickerDrivers(for input: Input) -> PickerDrivers {
        let autoDetectedLanguage = self.autoDetectedLanguage()

        let sourceLanguages: Driver<[LanguageProtocol]> = Driver.combineLatest(sourceLanguagesQueue.asDriver(), autoDetectedLanguage).map { $0.0.array + [$0.1] }
        let targetLanguages: Driver<[LanguageProtocol]> = targetLanguagesQueue.map { $0.array }.asDriver(onErrorJustReturn: [])

        let pickSupportedLanguages = Observable
            .combineLatest(Observable.merge(input.languagePickerQuery.asObservable(), isPickerNeeded.filter { $0 }.asObservable().map { _ in "" }), supportedLanguages)
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .default))
            .map { q, supported -> [Language] in
                let languages = supported?.languages ?? []
                let query = q.lowercased()
                return query.isEmpty ? languages : languages.filter { $0.full?.lowercased().contains(query) ?? false }
            }
            .asDriver(onErrorJustReturn: [])

        let pickedLanguage = input.languagePickerSelectedIndex
            .withLatestFrom(pickSupportedLanguages) { index, languages in
                languages[index.item]
            }
        pickedLanguage.drive(onNext: pick(language:)).disposed(by: disposeBag)
        return PickerDrivers(sourceLanguages: sourceLanguages,
                             targetLanguages: targetLanguages,
                             supportedLanguages: pickSupportedLanguages)
    }

    private func pick(language: Language) {
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

extension TranslateViewModel {
    private func swapLanguages() {
        let sourceLanguage = sourceLanguagesQueue.value[sourceLanguageIndex.value]
        let targetLanguage = targetLanguagesQueue.value[targetLanguageIndex.value]

        if !targetLanguagesQueue.value.contains(sourceLanguage) && !sourceLanguagesQueue.value.contains(targetLanguage) {
            naiveSwapLanguages()
            return
        }

        if let index = sourceLanguagesQueue.value.index(of: targetLanguage) {
            sourceLanguageIndex.accept(index)
        } else {
            var queue = sourceLanguagesQueue.value
            let (index, _) = queue.push(targetLanguage)
            sourceLanguagesQueue.accept(queue)
            sourceLanguageIndex.accept(index)
        }

        if let index = targetLanguagesQueue.value.index(of: sourceLanguage) {
            targetLanguageIndex.accept(index)
        } else {
            var queue = targetLanguagesQueue.value
            let (index, _) = queue.push(sourceLanguage)
            targetLanguagesQueue.accept(queue)
            targetLanguageIndex.accept(index)
        }
    }

    private func naiveSwapLanguages() {
        var lhs = sourceLanguagesQueue.value
        var rhs = targetLanguagesQueue.value

        let tmp = lhs[sourceLanguageIndex.value]
        lhs[sourceLanguageIndex.value] = rhs[targetLanguageIndex.value]
        rhs[targetLanguageIndex.value] = tmp

        sourceLanguagesQueue.accept(lhs)
        targetLanguagesQueue.accept(rhs)
    }
}
