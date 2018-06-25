//
//  TranslateViewModel.swift
//  Translate Bar
//
//  Created by Artem Bobrov on 13.06.2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

class TranslateViewModel {
	private let disposeBag = DisposeBag()
    private (set) var maxCharactersCount = 5000
	private let translateProvider = MoyaProvider<YandexTranslate>()

    var inputText = BehaviorRelay<String>(value: "")
    var outputText = BehaviorRelay<String>(value: "")

    lazy var traslatePreferences: Observable<TranslationPreferences> = {
        return translateProvider.rx
            .request(.getSupportedLanguages, callbackQueue: .global(qos: .userInteractive))
            .Rmap(to: TranslationPreferences.self)
            .asObservable()
    }()

	init() {
		inputText
            .filter { !$0.isEmpty }
            .debounce(1, scheduler: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
			.subscribe(onNext: { [unowned self] value in
                self.translate(text: value, source: Language(shortName: "en"), target: Language(shortName: "ru"))
                    .map { $0.text ?? "" }
                    .bind(to: self.outputText)
                    .disposed(by: self.disposeBag)
			})
			.disposed(by: disposeBag)
	}

    var isSuggestNeeded: Observable<Bool> {
        return inputText
                .map { $0.contains(" ") }
                .asObservable()
    }

    var text: Observable<String> {
        return Observable
                .of(inputText, outputText)
                .merge()
    }

    var limitationText: Observable<String> {
        return inputText
            .map { $0.count }
            .map {"\($0)/\(self.maxCharactersCount)"}
            .asObservable()
    }

    var clearButtonHidden: Observable<Bool> {
        return inputText
            .map { $0.isEmpty }
            .asObservable()
    }

    func translate(text: String, source: Language, target: Language) -> Observable<Translation> {
        return translateProvider
                .rx
                .request(.translate(from: source, to: target, text: text), callbackQueue: .global(qos: .userInteractive))
                .Rmap(to: Translation.self)
                .filter { $0.text != nil }
                .asObservable()
    }
}
