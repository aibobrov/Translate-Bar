//
//  SettingsService+Rx.swift
//  Translate Bar
//
//  Created by abobrov on 02/07/2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import RxSwift
import RxCocoa
import Magnet

extension Reactive where Base: SettingsService {
    var isShowIconInDock: Binder<Bool> {
        return Binder(self.base) { service, value in
            service.isShowIconInDock = value
        }
    }

    var isAutomaticallyTranslateClipboard: Binder<Bool> {
        return Binder(self.base) { service, value in
            service.isAutomaticallyTranslateClipboard = value
        }
    }

	var toggleAppShortcut: Binder<KeyCombo?> {
		return Binder(self.base) { service, value in
			service.toggleAppShortcut = value
		}
	}
}
