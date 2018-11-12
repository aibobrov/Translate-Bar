//
//  AppView.swift
//  TranslateBar
//
//  Created by Artem Bobrov on 08/11/2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa
import RxCocoa
import RxSwift

class AppView: NSView {
    @IBOutlet var topBar: TopBar!
    @IBOutlet var bottomBar: BottomBar!
    @IBOutlet var languagePick: LanguageSearch!
    @IBOutlet var translationView: TranslationView!

    override var intrinsicContentSize: NSSize {
        let topBarSize = topBar.bounds.size
        let isPickerNeeded = topBar.sourceLanguageSegmentedControl.isSelected(forSegment: topBar.sourceLanguageSegmentedControl.segmentCount - 1)
            || topBar.targetLanguageSegmentedControl.isSelected(forSegment: topBar.targetLanguageSegmentedControl.segmentCount - 1)

        let translateViewHeight = translationView.bounds.height
        let bottomBarHeight = bottomBar.bounds.height
        let languagePickerHeight = isPickerNeeded ? languagePick.bounds.height - translateViewHeight : 0

        return NSSize(
            width: topBarSize.width + 16,
            height: 8 + topBarSize.height + 8 + languagePickerHeight + translateViewHeight + 8 + bottomBarHeight + 4
        )
    }

    override func invalidateIntrinsicContentSize() {
        super.invalidateIntrinsicContentSize()
        DispatchQueue.main.asyncAfter(deadline: .now() + .microseconds(300)) {
            self.enclosingScrollView?.invalidateIntrinsicContentSize()
        }
    }
}

// MARK: TopView

extension AppView {
    var sourceLanguagePickerNeeded: ControlProperty<Bool> {
        return topBar.sourceLanguageSegmentedControl.rx.isSelected(with: topBar.sourceLanguageSegmentedControl.segmentCount - 1)
    }

    var targetLanguagePickerNeeded: ControlProperty<Bool> {
        return topBar.targetLanguageSegmentedControl.rx.isSelected(with: topBar.targetLanguageSegmentedControl.segmentCount - 1)
    }

    var sourceLanguageIndex: Observable<Int> {
        return topBar.sourceLanguageSegmentedControl.rx.selectedSegmentIndex.distinctUntilChanged()
            .filter { $0 != self.topBar.sourceLanguageSegmentedControl.segmentCount - 1 }
    }

    var targetLanguageIndex: Observable<Int> {
        return topBar.targetLanguageSegmentedControl.rx.selectedSegmentIndex.distinctUntilChanged()
            .filter { $0 != self.topBar.targetLanguageSegmentedControl.segmentCount - 1 }
    }
}
