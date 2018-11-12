//
//  YandexSpeller.swift
//  TranslateBar
//
//  Created by Artem Bobrov on 11/11/2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Moya

enum YandexSpeller {
    case spell(text: String, language: LanguageProtocol)
}

extension YandexSpeller: TargetType {
    var baseURL: URL {
        return URL(string: "https://speller.yandex.net/services/spellservice.json")!
    }

    var path: String {
        return "/checkText"
    }

    var method: Method {
        return .post
    }

    var sampleData: Data {
        return Data()
    }

    private struct ParameterKeys {
        static let text = "text"
        static let lang = "lang"
        static let ui = "ui"
    }

    var task: Task {
        switch self {
        case let .spell(text, language):
            return Task.requestParameters(
                parameters: [
                    ParameterKeys.text: text,
                    ParameterKeys.lang: language.short,
                    ParameterKeys.ui: Settings.ui
                ],
                encoding: URLEncoding.default
            )
        }
    }

    var headers: [String: String]? {
        return nil
    }
}
