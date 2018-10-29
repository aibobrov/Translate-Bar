//
//  Highlightable.swift
//  TranslateBar
//
//  Created by Artem Bobrov on 30.06.2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa

protocol Highlightable {
    var isHighlighted: Bool { get set }

    func highlight()
    func unhighlight()
}
