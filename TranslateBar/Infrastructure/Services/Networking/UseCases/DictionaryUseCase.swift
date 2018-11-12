//
//  DictionaryUseCase.swift
//  TranslateBar
//
//  Created by Artem Bobrov on 28/10/2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import RxSwift

public protocol DictionaryUseCase: SupportedLanguagesUseCase {
    func lookup(from source: LanguageProtocol, to target: LanguageProtocol, text: String) -> Observable<[DictionaryArticle]>
}
