//
//  NSViewController+Rx.swift
//  TranslateBar
//
//  Created by Artem Bobrov on 11/11/2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import RxCocoa
import RxSwift

public extension Reactive where Base: NSViewController {
    public var viewDidLoad: ControlEvent<Void> {
        let source = methodInvoked(#selector(Base.viewDidLoad)).map { _ in }
        return ControlEvent(events: source)
    }

    public var viewWillAppear: ControlEvent<Void> {
        let source = methodInvoked(#selector(Base.viewWillAppear)).map { _ in }
        return ControlEvent(events: source)
    }

    public var viewDidAppear: ControlEvent<Void> {
        let source = methodInvoked(#selector(Base.viewDidAppear)).map { _ in }
        return ControlEvent(events: source)
    }

    public var viewWillDisappear: ControlEvent<Void> {
        let source = methodInvoked(#selector(Base.viewWillDisappear)).map { _ in }
        return ControlEvent(events: source)
    }

    public var viewDidDisappear: ControlEvent<Void> {
        let source = methodInvoked(#selector(Base.viewDidDisappear)).map { _ in }
        return ControlEvent(events: source)
    }

    public var viewWillLayout: ControlEvent<Void> {
        let source = methodInvoked(#selector(Base.viewWillLayout)).map { _ in }
        return ControlEvent(events: source)
    }

    public var viewDidLayout: ControlEvent<Void> {
        let source = methodInvoked(#selector(Base.viewDidLayout)).map { _ in }
        return ControlEvent(events: source)
    }
}
