//
//  YandexTranslate.swift
//  Translate Bar
//
//  Created by Artem Bobrov on 10.06.2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Foundation
import Moya
import Keys

fileprivate let keys = TranslateBarKeys()

enum YandexTranslate  {
	case getSupportedLanguages
}

extension YandexTranslate: TargetType {
	var baseURL: URL {
		switch self {
		case .getSupportedLanguages:
			return URL(string: "https://translate.yandex.net")!
		}
	}

	var path: String {
		switch self {
		case .getSupportedLanguages:
			return "/api/v1.5/tr.json/getLangs"
		}
	}

	var method: Moya.Method {
		switch self {
		case .getSupportedLanguages:
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
		}
	}

	var headers: [String : String]? {
		return [
			"Content-Type": "application/x-www-form-urlencoded",
			"Accept": "*/*"
		]
	}

	var sampleData: Data {
		return Data()
	}
}
