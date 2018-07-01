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
    public func labels(for segments: CountableRange<Int>) -> Binder<[String?]> {
        return self.labels(for: segments.map { $0 })
    }

    public func labels(for segments: [Int]) -> Binder<[String?]> {
        return Binder(self.base) { (segmentedControl, labels) in
            for (index, label) in labels.enumerated() {
                segmentedControl.setLabel(label ?? "", forSegment: segments[index])
            }
        }
    }
}
