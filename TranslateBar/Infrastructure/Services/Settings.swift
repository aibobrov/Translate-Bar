//
//  Settings.swift
//  TranslateBar
//
//  Created by abobrov on 02/07/2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Foundation
import Magnet

public final class Settings: NSObject {
    static var ui: String {
        return Locale.current.languageCode == "ru" ? "ru" : "en"
    }

    static let shared = Settings()

    private var store = UserDefaults.standard
    private override init() {
        super.init()
    }

    public var isShowIconInDock: Bool {
        get {
            return store.bool(forKey: #function)
        }
        set {
            store.set(newValue, forKey: #function)
        }
    }

    public var isAutomaticallyTranslateClipboard: Bool {
        get {
            return store.bool(forKey: #function)
        }
        set {
            store.set(newValue, forKey: #function)
        }
    }

    public var toggleAppShortcut: KeyCombo? {
        get {
            guard let data = store.data(forKey: #function),
                let unarchiver = try? NSKeyedUnarchiver(forReadingFrom: data) else { return nil }

            return KeyCombo(coder: unarchiver)
        }
        set {
            guard let keyCombo = newValue else {
                store.set(nil, forKey: #function)
                return
            }
            let archiver = NSKeyedArchiver(requiringSecureCoding: false)
            keyCombo.encode(with: archiver)
            store.set(archiver.encodedData, forKey: #function)
        }
    }
}
