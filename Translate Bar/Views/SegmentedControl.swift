//
//  SegmentedControl.swift
//  Translate Bar
//
//  Created by abobrov on 27/06/2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa

class SegmentedCell: NSSegmentedCell {
    var singleSelectionSegments: [Int] = []

    override func setSelected(_ selected: Bool, forSegment segment: Int) {
        if singleSelectionSegments.contains(segment),
            let selectedSegment = singleSelectionSegments.first(where: { self.isSelected(forSegment: $0) }) {
            super.setSelected(false, forSegment: selectedSegment)
        }
        super.setSelected(selected, forSegment: segment)
    }
}

class SegmentedControl: NSSegmentedControl {
    var singleSelectionSegments: [Int] = [] {
        didSet {
            (self.cell as? SegmentedCell)?.singleSelectionSegments = singleSelectionSegments
        }
    }
}
