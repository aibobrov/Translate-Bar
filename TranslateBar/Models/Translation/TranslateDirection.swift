//
//  TranslateDirection.swift
//  TranslateBar
//
//  Created by Artem Bobrov on 14.07.2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Foundation

struct TranslateDirection {
    public let source: LanguageProtocol
    public let target: LanguageProtocol
}

extension TranslateDirection: Equatable {
    static func == (lhs: TranslateDirection, rhs: TranslateDirection) -> Bool {
        return lhs.source == rhs.source && lhs.target == rhs.target
    }
}

extension TranslateDirection {
    public var string: String {
        if let source = self.source as? AutoDetectedLanguage {
            guard let realSource = source.real else { return target.short }
            return "\(realSource.short)-\(target.short)"
        }
        return "\(source.short)-\(target.short)"
    }
}
