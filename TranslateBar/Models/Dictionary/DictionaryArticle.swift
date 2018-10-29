//
//  DictionaryArticle.swift
//  TranslateBar
//
//  Created by Artem Bobrov on 27.07.2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Foundation

public struct DictionaryArticle: Codable {
    let text: String
    var partOfSpeech: String?
    var transcription: String?

    struct DictionaryTranslation: Codable {
        let text: String
        var partOfSpeech: String?
        var aspect: String?

        var synonyms: [DictionaryTranslation]?
        var meanings: [DictionaryTranslation]?
        var examples: [DictionaryArticle]?

        private enum CodingKeys: String, CodingKey {
            case text
            case partOfSpeech = "pos"
            case aspect = "asp"
            case synonyms = "syn"
            case meanings = "mean"
            case examples = "ex"
        }
    }

    var translations: [DictionaryTranslation] = []
    private enum CodingKeys: String, CodingKey {
        case text
        case partOfSpeech = "pos"
        case transcription = "ts"
        case translations = "tr"
    }
}
