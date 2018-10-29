//
//  AutoDetectedLanguage.swift
//  TranslateBar
//
//  Created by Artem Bobrov on 18.07.2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa

struct AutoDetectedLanguage: LanguageProtocol {
    public var short: String {
        return "auto"
    }

    public var full: String? {
        return real?.full
    }

    public var real: Language?
}

extension AutoDetectedLanguage: CustomStringConvertible {
    public var description: String {
        guard let language = real else { return "определить язык" }
        return "\(language.description) (определенный язык)"
    }
}

extension AutoDetectedLanguage: Equatable {}

extension AutoDetectedLanguage: Hashable {
    public var hashValue: Int {
        return short.hashValue
    }
}

extension AutoDetectedLanguage: ImageRepresentable {
    public var imageName: NSImage.Name {
        return NSImage.Name(short)
    }
}
