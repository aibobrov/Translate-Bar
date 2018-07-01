//
//  SegmentedControl+Cell.swift
//  Translate Bar
//
//  Created by abobrov on 27/06/2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa

class SegmentedCell: NSSegmentedCell {
    var singleSelectionSegments: [Int] = []

    override func setSelected(_ selected: Bool, forSegment segment: Int) {
		guard singleSelectionSegments.contains(segment) else {
			super.setSelected(selected, forSegment: segment)
			return
		}

		let selectedSegments = singleSelectionSegments.filter { self.isSelected(forSegment: $0) && $0 != segment }
		if selectedSegments.count == 1 {
			selectedSegments.forEach { super.setSelected(false, forSegment: $0) }
			super.setSelected(selected, forSegment: segment)
		}
    }
}

class SegmentedControl: NSSegmentedControl {
    var singleSelectionSegments: [Int] = [] {
        didSet {
            (self.cell as? SegmentedCell)?.singleSelectionSegments = singleSelectionSegments
        }
    }
}
