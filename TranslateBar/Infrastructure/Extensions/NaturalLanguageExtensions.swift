//
//  NaturalLanguageExtensions.swift
//  TranslateBar
//
//  Created by Artem Bobrov on 11/11/2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import NaturalLanguage

extension NLLanguageRecognizer {
    func dominantLanguage(for string: String) -> String? {
        processString(string)
        return dominantLanguage?.rawValue
    }
}
