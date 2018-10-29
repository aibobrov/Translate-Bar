//
//  TranslationPreferences.swift
//  TranslateBar
//
//  Created by Artem Bobrov on 23.07.2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Moya
import RxCocoa
import RxSwift
import RxSwiftExt

class TranslationPreferences {
    // MARK: - Private stored properties

    private let disposeBag = DisposeBag()
    private let translateProvider = MoyaProvider<YandexTranslate>()
    private let dictionartProvider = MoyaProvider<YandexDictionary>()
    private let serialScheduler = SerialDispatchQueueScheduler(internalSerialQueueName: "TranslationPreferences.SerialDispatchQueueScheduler")

    // MARK: - Public stored properties

    public var translationSupportedLanguages = BehaviorRelay<SupportedLanguages>(value: SupportedLanguages())
    public var dictionarySupportedLanguages = BehaviorRelay<SupportedLanguages>(value: SupportedLanguages())

    // MARK: - Constructors

    public init() {
        update()
    }
}

// MARK: - Public API

extension TranslationPreferences {
    public func update() {
        updateTranslationSupportedLanguages()
        updateDictionarySupportedLanguages()
    }
}

// MARK: - Private API

extension TranslationPreferences {
    private func updateTranslationSupportedLanguages() {
        fetchTranslationSupportedLanguages()
            .subscribeOn(serialScheduler)
            .asObservable()
            .bind(to: translationSupportedLanguages)
            .disposed(by: disposeBag)
    }

    private func updateDictionarySupportedLanguages() {
        translationSupportedLanguages
            .subscribeOn(serialScheduler)
            .flatMapLatest { _ in
                self.fetchDictionarySupportedLanguages()
                    .asObservable()
                    .map({ dictionarySupportedLanguages in
//                        dictionarySupportedLanguages.update(with: translationSupportedLanguages.languages)
                        dictionarySupportedLanguages
                    })
            }
            .bind(to: dictionarySupportedLanguages)
            .disposed(by: disposeBag)
    }

    private func fetchTranslationSupportedLanguages() -> Single<SupportedLanguages> {
        return translateProvider.rx
            .request(.getSupportedLanguages)
            .map(SupportedLanguages.self)
    }

    private func fetchDictionarySupportedLanguages() -> Single<SupportedLanguages> {
        return dictionartProvider.rx
            .request(.getSupportedLanguages)
            .map(SupportedLanguages.self)
    }
}
