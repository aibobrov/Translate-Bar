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
    func asDriverOnErrorJustComplete() -> Driver<E> {
        return asDriver { _ in
            Driver.empty()
        }
    }
}
