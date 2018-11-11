//
//  ApplyOrHide.swift
//  TranslateBar
//
//  Created by Artem Bobrov on 10/11/2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa

protocol ApplyOrHide {
    associatedtype Value
    func applyOfHide(value: Value?)
}

extension NSTextField: ApplyOrHide {
    func applyOfHide(value: String?) {
        isHidden = value == nil
        if let data = value {
            stringValue = data
        }
    }
}
