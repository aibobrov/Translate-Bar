//
//  SettingsView.swift
//  TranslateBar
//
//  Created by Artem Bobrov on 11/11/2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa
import ITSwitch
import KeyHolder
import Magnet

class SettingsView: NSView {
    @IBOutlet var closeButton: NSButton!
    @IBOutlet var showInDockSwitcher: ITSwitch!
    @IBOutlet var translateFromClipboardSwitcher: ITSwitch!
    @IBOutlet var shortcutRecordView: RecordView!
}
