//
//  NSSegmentedControlExtension.swift
//  Translate Bar
//
//  Created by abobrov on 26/06/2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa
extension NSSegmentedControl {
    var selectedSegments: [Int] {
        return (0..<self.segmentCount).filter { self.isSelected(forSegment: $0) }.map { $0 }
    }
}
