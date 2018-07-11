//
//  SettingsViewModel.swift
//  Translate Bar
//
//  Created by Artem Bobrov on 02.07.2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import RxSwift
import RxCocoa
import Cocoa
import Magnet

class SettingsViewModel {
	private let disposeBag = DisposeBag()

	public var isShowIconInDock = BehaviorRelay<Bool?>(value: nil)
	public var isAutomaticallyTranslateClipboard = BehaviorRelay<Bool?>(value: nil)
	public var shortcutToggleApp = BehaviorRelay<KeyCombo?>(value: nil)
    public var shortcutDidClear = BehaviorRelay<()?>(value: nil)

	init() {
		setupStoreBindings()
		updateSettings()
	}

	private func setupStoreBindings() {
        isShowIconInDock
            .filter { $0 != nil }
            .map { $0! }
			.bind(to: SettingsService.shared.rx.isShowIconInDock)
			.disposed(by: disposeBag)
        isAutomaticallyTranslateClipboard
            .filter { $0 != nil }
            .map { $0! }
			.bind(to: SettingsService.shared.rx.isAutomaticallyTranslateClipboard)
			.disposed(by: disposeBag)
        shortcutToggleApp
            .filter { $0 != nil }
            .map { $0! }
			.bind(to: SettingsService.shared.rx.toggleAppShortcut)
			.disposed(by: disposeBag)
	}

	private func updateSettings() {
        let appDelegate = NSApplication.shared.appDelegate

		isShowIconInDock
            .filter { $0 != nil }
            .map { $0! }
			.debounce(0.3, scheduler: MainScheduler.asyncInstance)
			.map { value -> NSApplication.ActivationPolicy in
				value ? .regular : .accessory
			}
			.subscribe(onNext: { policy in
				NSApplication.shared.setActivationPolicy(policy)
			})
			.disposed(by: disposeBag)

		shortcutToggleApp
            .filter { $0 != nil }
            .map { $0! }
            .subscribe(onNext: { keyCombo in
                appDelegate.setupToggleShortcut(with: keyCombo)
            })
            .disposed(by: disposeBag)
        shortcutDidClear
            .filter { $0 != nil }
            .map { $0! }
            .subscribe(onNext: { _ in
                SettingsService.shared.toggleAppShortcut = nil
                appDelegate.setupToggleShortcut(with: nil)
            })
            .disposed(by: disposeBag)
	}

}
