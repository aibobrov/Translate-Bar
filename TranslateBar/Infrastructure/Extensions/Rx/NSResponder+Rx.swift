//
//  NSResponder+Rx.swift
//  TranslateBar
//
//  Created by abobrov on 30/08/2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa
import RxCocoa
import RxSwift

public extension Reactive where Base: NSResponder {
    var mouseDown: Observable<Base> {
        return methodInvoked(#selector(NSResponder.mouseDown(with:))).map { _ in self.base }
    }
}
