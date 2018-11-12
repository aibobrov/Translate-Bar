//
//  Translation.swift
//  TranslateBar
//
//  Created by Artem Bobrov on 14.07.2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa

public struct Translation: Decodable {
    var from: Language?
    var to: Language?
    public var text: String?

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let translations = try container.decode([String].self, forKey: .texts)
        let langs = (try container.decode(String.self, forKey: .langs)).split(separator: "-")
        from = Language(short: String(langs.first!))
        to = Language(short: String(langs.last!))
        text = translations.first
    }

    private enum CodingKeys: String, CodingKey {
        case texts = "text"
        case langs = "lang"
    }
}
