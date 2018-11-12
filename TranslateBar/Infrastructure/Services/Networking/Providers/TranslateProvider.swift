//
//  TranslateProvider.swift
//  Translate Bar
//
//  Created by Artem Bobrov on 28/10/2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Moya
import NaturalLanguage
import RxCocoa
import RxSwift

public final class TranslateProvider: TranslateUseCase {
    private let _provider = MoyaProvider<YandexTranslate>()
    private let _supportedLanguages = BehaviorRelay<SupportedLanguages>(value: SupportedLanguages())
    private let _languageRecognizer = NLLanguageRecognizer()
    private var _supportedLanguagesDisposable: Disposable?

    public init() {
        _supportedLanguagesDisposable = fetchSupportedLanguages().bind(to: _supportedLanguages)
    }

    deinit {
        _supportedLanguagesDisposable?.dispose()
    }

    private func fetchSupportedLanguages() -> Observable<SupportedLanguages> {
        return _provider.rx.request(.getSupportedLanguages).map(SupportedLanguages.self).asObservable()
    }

    public func supportedLanguages() -> Observable<SupportedLanguages> {
        _supportedLanguagesDisposable = fetchSupportedLanguages().bind(to: _supportedLanguages)
        return _supportedLanguages.asObservable()
    }

    public func detectLanguage(text: String) -> Observable<Language?> {
        return _provider.rx
            .request(.detectLanguage(text: text), callbackQueue: .global(qos: .userInteractive))
            .mapString(atKeyPath: "lang")
            .catchErrorJustReturn(_languageRecognizer.dominantLanguage(for: text) ?? "")
            .map { lang in
                self._supportedLanguages.value.languages.first(where: { $0.short == lang })
            }
            .asObservable()
    }

    public func translate(from source: LanguageProtocol, to target: LanguageProtocol, text: String) -> Observable<Translation> {
        return _provider.rx.request(.translate(from: source, to: target, text: text)).map(Translation.self).asObservable()
    }
}
