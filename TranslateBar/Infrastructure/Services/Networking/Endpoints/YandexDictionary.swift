//
//  YandexDictionary.swift
//  TranslateBar
//
//  Created by Artem Bobrov on 27.07.2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Keys
import Moya

private let keys = TranslateBarKeys()

enum YandexDictionary {
    case getSupportedLanguages
    case lookup(from: LanguageProtocol, to: LanguageProtocol, text: String)
}

extension YandexDictionary: TargetType {
    var baseURL: URL {
        return URL(string: "https://dictionary.yandex.net")!
    }

    var path: String {
        switch self {
        case .getSupportedLanguages:
            return "/api/v1/dicservice.json/getLangs"
        case .lookup:
            return "/api/v1/dicservice.json/lookup"
        }
    }

    var method: Moya.Method {
        return .post
    }

    var sampleData: Data {
        return Data()
    }

    private struct ParameterKeys {
        static let key = "key"
        static let text = "text"
        static let language = "lang"
        static let speaker = "speaker"
        static let format = "format"
        static let ui = "ui"
    }

    var task: Task {
        switch self {
        case .getSupportedLanguages:
            return .requestParameters(
                parameters: [
                    ParameterKeys.key: keys.yandexDictionaryKey,
                    ParameterKeys.ui: Settings.ui
                ],
                encoding: URLEncoding.default
            )
        case let .lookup(from, to, text):
            let direction = TranslateDirection(source: from, target: to)
            return .requestParameters(
                parameters: [
                    ParameterKeys.key: keys.yandexDictionaryKey,
                    ParameterKeys.text: text,
                    ParameterKeys.language: direction.string,
                    ParameterKeys.ui: Settings.ui
                ],
                encoding: URLEncoding.default
            )
        }
    }

    var headers: [String: String]? {
        return [
            "Content-Type": "application/x-www-form-urlencoded",
            "Accept": "*/*"
        ]
    }
}
