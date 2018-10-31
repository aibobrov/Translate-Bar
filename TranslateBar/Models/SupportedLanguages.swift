//
//  SupportedLanguages.swift
//  TranslateBar
//
//  Created by Artem Bobrov on 27/10/2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Foundation

public struct SupportedLanguages: Decodable {
    public var languages: [Language] = []
    public var directions: [Language: [Language]] = [:]

    private enum CodingKeys: String, CodingKey {
        case directions = "dirs"
        case languages = "langs"
    }

    public init() {}

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let dirs = try container.decode([String].self, forKey: .directions)
        let langs = try container.decode([String: String].self, forKey: .languages)

        let directions = dirs.map { string -> (Language, Language) in
            let data = string.split(separator: "-")
            return (Language(short: String(data.first!)), Language(short: String(data.last!)))
        }

        for var pair in directions {
            pair.0.full = langs[pair.0.short]
            pair.1.full = langs[pair.1.short]
            if self.directions[pair.0] == nil {
                self.directions[pair.0] = [pair.1]
            } else {
                self.directions[pair.0]!.append(pair.1)
            }
        }

        languages = langs.map { Language(short: $0.key, full: $0.value) }.sorted(by: { $0.full! < $1.full! })
    }
}
