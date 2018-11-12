//
//  TopSelectionBar.swift
//  TranslateBar
//
//  Created by Artem Bobrov on 27/10/2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa

class TopBar: SVSizedView {
    @IBOutlet var swapButton: NSButton!
    @IBOutlet var sourceLanguageSegmentedControl: SelfSizedSegmentedControl!
    @IBOutlet var targetLanguageSegmentedControl: SelfSizedSegmentedControl!
}
