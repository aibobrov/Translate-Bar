//
//  SettingsService+Rx.swift
//  TranslateBar
//
//  Created by abobrov on 02/07/2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Magnet
import RxCocoa
import RxSwift

extension Reactive where Base: Settings {
    var isShowIconInDock: Binder<Bool> {
        return Binder(base) { service, value in
            service.isShowIconInDock = value
        }
    }

    var isAutomaticallyTranslateClipboard: Binder<Bool> {
        return Binder(base) { service, value in
            service.isAutomaticallyTranslateClipboard = value
        }
    }

    var toggleAppShortcut: Binder<KeyCombo?> {
        return Binder(base) { service, value in
            service.toggleAppShortcut = value
        }
    }
}
