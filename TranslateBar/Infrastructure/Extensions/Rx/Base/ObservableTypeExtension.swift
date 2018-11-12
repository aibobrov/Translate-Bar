//
//  ObservableTypeExtension.swift
//  AB_IOS_Flickr
//
//  Created by Artem Bobrov on 04/10/2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import RxCocoa
import RxSwift

extension ObservableType {
    public func asDriverOnErrorJustComplete() -> Driver<E> {
        return asDriver { _ in
            Driver.empty()
        }
    }

    public func unwrap<T>() -> Observable<T> where E == T? {
        return filter { $0 != nil }.map { $0! }
    }
}

infix operator <->: DefaultPrecedence

func <-> <T>(property: ControlProperty<T>, relay: BehaviorRelay<T>) -> Disposable {
    let bindToUIDisposable = relay.bind(to: property)
    let bindToRelay = property
        .subscribe(onNext: { n in
            relay.accept(n)
        }, onCompleted: {
            bindToUIDisposable.dispose()
        })

    return Disposables.create(bindToUIDisposable, bindToRelay)
}
