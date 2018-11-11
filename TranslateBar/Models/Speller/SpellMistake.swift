//
//  SpellMistake.swift
//  TranslateBar
//
//  Created by Artem Bobrov on 11/11/2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Foundation

struct SpellMistake: Decodable {
    let position: Int
    let length: Int
    let word: String
    var values: [String] = []

    private enum CodingKeys: String, CodingKey {
        case position = "pos"
        case length = "len"
        case word
        case values = "s"
    }
}
