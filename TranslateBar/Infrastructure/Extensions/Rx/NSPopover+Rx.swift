//
//  NSPopover+Rx.swift
//  TranslateBar
//
//  Created by abobrov on 02/07/2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa
import RxCocoa
import RxSwift

extension Reactive where Base: NSPopover {
    var isShown: Observable<Bool> {
        return observe(Bool.self, #keyPath(NSPopover.isShown)).unwrap()
    }

    var contentViewController: Binder<NSViewController?> {
        return Binder(base) { popover, viewController in
            popover.contentViewController = viewController
        }
    }
}
