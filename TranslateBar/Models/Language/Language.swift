//
//  Language.swift
//  TranslateBar
//
//  Created by Artem Bobrov on 11.06.2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa

public struct Language: LanguageProtocol {
    public let short: String
    public var full: String?
}

extension Language {
    public init(short: String) {
        self.init(short: short, full: nil)
    }
}

extension Language: CustomStringConvertible {
    public var description: String {
        return full?.lowercased() ?? ""
    }
}

extension Language: Equatable {}

extension Language: Hashable {
    public var hashValue: Int {
        return short.hashValue
    }
}

extension Language: ImageRepresentable {
    public var imageName: NSImage.Name {
        return NSImage.Name(short)
    }
}

extension Language {
    static let english = Language(short: "en", full: L10n.en)
    static let russian = Language(short: "ru", full: L10n.ru)
    static let german = Language(short: "de", full: L10n.de)
}
