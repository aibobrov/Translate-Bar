//
//  SpellerUseCase.swift
//  TranslateBar
//
//  Created by Artem Bobrov on 11/11/2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import RxSwift

protocol SpellerUseCase {
    func mistakes(for text: String, language: LanguageProtocol) -> Observable<[SpellMistake]>
}
