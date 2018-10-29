//
//  NSButton+Rx.swift
//  TranslateBar
//
//  Created by abobrov on 02/07/2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa
import RxCocoa
import RxSwift

extension Reactive where Base: NSButton {
    var state: ControlProperty<NSControl.StateValue> {
        return controlProperty(getter: { button in
            button.state
        }, setter: { button, state in
            button.state = state
        })
    }

    var image: Binder<NSImage?> {
        return Binder(base) { button, image in
            button.image = image
        }
    }
}
