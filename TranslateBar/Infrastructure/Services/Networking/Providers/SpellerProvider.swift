//
//  SpellerProvider.swift
//  TranslateBar
//
//  Created by Artem Bobrov on 11/11/2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Moya
import RxSwift

public final class SpellerProvider: SpellerUseCase {
    private let _provider = MoyaProvider<YandexSpeller>()

    func mistakes(for text: String, language: LanguageProtocol) -> Observable<[SpellMistake]> {
        guard SpellerProvider.supportedLanguages.contains(where: { $0.short == language.short }) else { return .just([]) }
        return _provider.rx
            .request(.spell(text: text, language: language))
            .map([SpellMistake].self)
            .asObservable()
    }

    private static let supportedLanguages: [LanguageProtocol] = [Language.english, Language.russian]
}
