//
//  TranslationTableCellViewAction.swift
//  TranslateBar
//
//  Created by Artem Bobrov on 11/11/2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Foundation

extension NSNotification.Name {
    static let linkClicked = NSNotification.Name(rawValue: "NSNotification.Name.LinkClicked")
}

enum TranslateClickAction: String {
    case keep
    case swap

    static let separator: Character = "▾"
}

struct OnLinkActionQuery {
    let action: TranslateClickAction
    let query: String
}
