//
//  ITSwitch+Rx.swift
//  Translate Bar
//
//  Created by abobrov on 02/07/2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa
import RxCocoa
import RxSwift
import ITSwitch

extension Reactive where Base: ITSwitch {
    var isChecked: ControlProperty<Bool> {
        return controlProperty(getter: { switcher in
            switcher.checked
        }, setter: { switcher, value in
            switcher.checked = value
        })
    }
}
