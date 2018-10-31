//
//  NSSegmentedControl+Rx.swift
//  TranslateBar
//
//  Created by abobrov on 25/06/2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa
import RxCocoa
import RxSwift

extension Reactive where Base: NSSegmentedControl {
    public var selectedSegmentIndex: ControlProperty<Int> {
        return value
    }

    public var value: ControlProperty<Int> {
        return controlProperty(
            getter: { segmentedControl in
                segmentedControl.selectedSegment
            }, setter: { segmentedControl, value in
                segmentedControl.selectedSegment = value
            }
        )
    }

    public func isSelected(with segment: Int) -> ControlProperty<Bool> {
        return controlProperty(getter: { segmentedControl in
            segmentedControl.isSelected(forSegment: segment)
        }, setter: { segmentedControl, value in
            segmentedControl.setSelected(value, forSegment: segment)
        })
    }

    public var selectSegment: Binder<Int> {
        return Binder(base) { segmentedControl, value in
            segmentedControl.setSelected(true, forSegment: value)
        }
    }

    public var deselectSegment: Binder<Int> {
        return Binder(base) { segmentedControl, value in
            segmentedControl.setSelected(false, forSegment: value)
        }
    }

    public func enabledForSegment(at index: Int) -> Binder<Bool> {
        return Binder(base) { (segmentedControl, segmentEnabled) -> Void in
            segmentedControl.setEnabled(segmentEnabled, forSegment: index)
        }
    }

    public func titleForSegment(at index: Int) -> Binder<String?> {
        return Binder(base) { (segmentedControl, title) -> Void in
            segmentedControl.setLabel(title ?? "", forSegment: index)
        }
    }

    public func imageForSegment(at index: Int) -> Binder<NSImage?> {
        return Binder(base) { (segmentedControl, image) -> Void in
            segmentedControl.setImage(image, forSegment: index)
        }
    }
}
