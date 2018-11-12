//
//  SupportUtls.swift
//  TranslateBar
//
//  Created by Artem Bobrov on 01.07.2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa
import RxCocoa
import RxSwift

func rx_swap<T>(_ lhs: BehaviorRelay<T>, _ rhs: BehaviorRelay<T>) {
    let tmp = lhs.value
    lhs.accept(rhs.value)
    rhs.accept(tmp)
}
