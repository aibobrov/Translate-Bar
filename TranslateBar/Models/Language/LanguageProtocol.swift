//
//  LanguageProtocol.swift
//  TranslateBar
//
//  Created by Artem Bobrov on 18.07.2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa

protocol ImageRepresentable {
    var imageName: NSImage.Name { get }
}

public protocol LanguageProtocol: CustomStringConvertible {
    var short: String { get }
    var full: String? { get }
}

public func == (lhs: LanguageProtocol, rhs: LanguageProtocol) -> Bool {
    return lhs.short == rhs.short && lhs.full == rhs.full
}

public func == <T: LanguageProtocol>(lhs: T, rhs: T) -> Bool {
    return lhs.short == rhs.short && lhs.full == rhs.full
}
