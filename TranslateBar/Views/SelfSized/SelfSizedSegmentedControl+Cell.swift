//
//  SelfSizedSegmentedControl+Cell.swift
//  TranslateBar
//
//  Created by abobrov on 27/06/2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa
import RxCocoa
import RxSwift

class SelfSizedSegmentedCell: NSSegmentedCell {
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

class SelfSizedSegmentedControl: NSSegmentedControl {
    @IBInspectable
    var segmentLabelOffset: CGFloat = 0

    var singleSelectionSegments: [Int] = [] {
        didSet {
            (self.cell as? SelfSizedSegmentedCell)?.singleSelectionSegments = singleSelectionSegments
        }
    }

    override func setLabel(_ label: String, forSegment segment: Int) {
        super.setLabel(label, forSegment: segment)
        setWidth(contentWidth(for: segment), forSegment: segment)
    }

    private func contentWidth(for segment: Int) -> CGFloat {
        guard let text = self.label(forSegment: segment), let font = self.font else { return 0 }
        let attributedString = NSAttributedString(string: text, attributes: [.font: font])
        return attributedString.size().width + segmentLabelOffset * 2
    }
}
