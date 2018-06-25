//
//  CustomNSSegmentedControl+Rx.swift
//  Translate Bar
//
//  Created by abobrov on 25/06/2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import RxSwift
import RxCocoa

extension Reactive where Base: NSSegmentedControl {
    public var labels: Binder<[String?]> {
        return Binder(self.base) { (segmentedControl, labels) in
            segmentedControl.segmentCount = labels.count
            for (index, label) in labels.enumerated() {
                segmentedControl.setLabel(label ?? "", forSegment: index)
            }
        }
    }
}
