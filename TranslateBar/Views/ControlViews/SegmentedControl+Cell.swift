//
//  SegmentedControl+Cell.swift
//  TranslateBar
//
//  Created by abobrov on 27/06/2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa
import RxCocoa
import RxSwift

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
    @IBInspectable
    var segmentLabelOffset: CGFloat = 0

    fileprivate let widthChangedManually = PublishSubject<(String, Int)>()

    var singleSelectionSegments: [Int] = [] {
        didSet {
            (self.cell as? SegmentedCell)?.singleSelectionSegments = singleSelectionSegments
        }
    }

    override func setLabel(_ label: String, forSegment segment: Int) {
        super.setLabel(label, forSegment: segment)
        setWidth(contentWidth(for: segment), forSegment: segment)
        widthChangedManually.onNext((label, segment))
    }

    func contentWidth(for segment: Int) -> CGFloat {
        guard let text = self.label(forSegment: segment), let font = self.font else { return 0 }
        let attributedString = NSAttributedString(string: text, attributes: [.font: font])
        return attributedString.size().width + segmentLabelOffset * 2
    }

    var contentWidth: CGFloat {
        return (0 ..< segmentCount).reduce(0, { $0 + self.contentWidth(for: $1) })
    }
}

extension Reactive where Base: SegmentedControl {
    var widthChangedManually: Observable<(String, Int)> {
        return base.widthChangedManually.asObserver()
    }
}
