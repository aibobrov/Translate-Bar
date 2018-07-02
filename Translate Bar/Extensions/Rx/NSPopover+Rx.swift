//
//  NSPopover+Rx.swift
//  Translate Bar
//
//  Created by abobrov on 02/07/2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import RxSwift
import RxCocoa
import Cocoa

extension Reactive where Base: NSPopover {
    var isShown: Observable<Bool> {
        return observe(Bool.self, #keyPath(NSPopover.isShown))
            .map { $0 ?? false }
    }
}
