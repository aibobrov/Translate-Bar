//
//  NSSegmentedControl+Rx.swift
//  Translate Bar
//
//  Created by abobrov on 25/06/2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa
import RxSwift
import RxCocoa

extension Reactive where Base: NSSegmentedControl {
    public var selectedSegmentIndex: ControlProperty<Int> {
        return value
    }

    public var value: ControlProperty<Int> {
        return base.rx.controlProperty(
            getter: { segmentedControl in
                segmentedControl.selectedSegment
            }, setter: { segmentedControl, value in
                segmentedControl.selectedSegment = value
            }
        )
    }

	public func isSelected(for segment: Int) -> ControlProperty<Bool> {
		return base.rx.controlProperty(getter: { segmentedControl in
			segmentedControl.isSelected(forSegment: segment)
		}, setter: { segmentedControl, value in
			segmentedControl.setSelected(value, forSegment: segment)
		})
	}

    public func enabledForSegment(at index: Int) -> Binder<Bool> {
        return Binder(self.base) { (segmentedControl, segmentEnabled) -> Void in
            segmentedControl.setEnabled(segmentEnabled, forSegment: index)
        }
    }

    public func titleForSegment(at index: Int) -> Binder<String?> {
        return Binder(self.base) { (segmentedControl, title) -> Void in
            segmentedControl.setLabel(title ?? "", forSegment: index)
        }
    }

    public func imageForSegment(at index: Int) -> Binder<NSImage?> {
        return Binder(self.base) { (segmentedControl, image) -> Void in
            segmentedControl.setImage(image, forSegment: index)
        }
    }
}
