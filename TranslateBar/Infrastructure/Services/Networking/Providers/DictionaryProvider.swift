//
//  DictionaryProvider.swift
//  Translate Bar
//
//  Created by Artem Bobrov on 28/10/2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Moya
import RxSwift

public final class DictionaryProvider: DictionaryUseCase {
    private let _provider = MoyaProvider<YandexDictionary>()
    private let _supportedLanguages = BehaviorSubject<SupportedLanguages>(value: SupportedLanguages())
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

    public func lookup(from source: LanguageProtocol, to target: LanguageProtocol, text: String) -> Observable<[DictionaryArticle]> {
        return _provider.rx.request(.lookup(from: source, to: target, text: text))
            .map([DictionaryArticle].self, atKeyPath: "def")
            .asObservable()
    }
}
