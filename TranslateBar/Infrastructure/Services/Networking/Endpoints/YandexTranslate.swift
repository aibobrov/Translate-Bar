//
//  YandexTranslate.swift
//  TranslateBar
//
//  Created by Artem Bobrov on 10.06.2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Foundation
import Keys
import Moya

private let keys = TranslateBarKeys()

enum YandexTranslate {
    case getSupportedLanguages
    case detectLanguage(text: String)
    case translate(from: LanguageProtocol, to: LanguageProtocol, text: String)
}

extension YandexTranslate: TargetType {
    var baseURL: URL {
        switch self {
        case .getSupportedLanguages, .detectLanguage, .translate:
            return URL(string: "https://translate.yandex.net")!
        }
    }

    var path: String {
        switch self {
        case .getSupportedLanguages:
            return "/api/v1.5/tr.json/getLangs"
        case .detectLanguage:
            return "/api/v1.5/tr.json/detect"
        case .translate:
            return "/api/v1.5/tr.json/translate"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getSupportedLanguages, .detectLanguage, .translate:
            return .post
        }
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
                parameters: [ParameterKeys.ui: "ru", ParameterKeys.key: keys.yandexTranslateKey],
                encoding: URLEncoding.default
            )
        case let .detectLanguage(text):
            return .requestParameters(
                parameters: [ParameterKeys.key: keys.yandexTranslateKey, ParameterKeys.text: text],
                encoding: URLEncoding.default
            )
        case let .translate(from, to, text):
            let direction = TranslateDirection(source: from, target: to)
            return .requestParameters(
                parameters: [
                    ParameterKeys.key: keys.yandexTranslateKey,
                    ParameterKeys.language: direction.string,
                    ParameterKeys.text: text
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

    var sampleData: Data {
        return Data()
    }
}
