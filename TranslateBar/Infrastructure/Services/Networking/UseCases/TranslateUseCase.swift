//
//  TranslateUseCase.swift
//  TranslateBar
//
//  Created by Artem Bobrov on 28/10/2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import RxSwift

public protocol TranslateUseCase: SupportedLanguagesUseCase {
    func detectLanguage(text: String) -> Observable<Language?>

    func translate(from source: LanguageProtocol, to target: LanguageProtocol, text: String) -> Observable<Translation>
}
