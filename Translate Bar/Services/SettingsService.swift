//
//  SettingsService.swift
//  Translate Bar
//
//  Created by abobrov on 02/07/2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Foundation
import Magnet

class SettingsService: NSObject {
	static let shared = SettingsService()

	private var store = UserDefaults.standard
    private override init() { super.init() }

    var isShowIconInDock: Bool {
        get {
            return store.bool(forKey: #function)
        }
        set {
            store.set(newValue, forKey: #function)
        }
    }

    var isAutomaticallyTranslateClipboard: Bool {
        get {
            return store.bool(forKey: #function)
        }
        set {
            store.set(newValue, forKey: #function)
        }
    }

	var toggleAppShortcut: KeyCombo? {
		get {
			guard let data = store.data(forKey: #function) else { return nil }

			let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
			return KeyCombo(coder: unarchiver)
		}
		set {
			guard let keyCombo = newValue else {
                store.set(nil, forKey: #function)
                return
            }
			let data = NSMutableData()
			let archiver = NSKeyedArchiver(forWritingWith: data)
			keyCombo.encode(with: archiver)
			store.set(archiver.encodedData, forKey: #function)
		}
	}
}
