//
//  NSButton+Rx.swift
//  Translate Bar
//
//  Created by abobrov on 02/07/2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import RxSwift
import RxCocoa
import Cocoa

extension Reactive where Base: NSButton {
    var state: ControlProperty<NSControl.StateValue> {
        return self.controlProperty(getter: { button in
            button.state
        }, setter: { (button, state) in
            button.state = state
        })
    }
}
