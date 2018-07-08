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

	public var isLaunchedAtLogin = BehaviorRelay<Bool>(value: false)
	public var isShowIconInDock = BehaviorRelay<Bool>(value: false)
	public var isAutomaticallyTranslateClipboard = BehaviorRelay<Bool>(value: false)
	public var shortcutToggleApp = BehaviorRelay<KeyCombo?>(value: nil)

	init() {
		setupStoreBindings()
		updateSettings()
	}

	private func setupStoreBindings() {
		isLaunchedAtLogin
			.bind(to: SettingsService.shared.rx.isLaunchedAtLogin)
			.disposed(by: disposeBag)
		isShowIconInDock
			.bind(to: SettingsService.shared.rx.isShowIconInDock)
			.disposed(by: disposeBag)
		isAutomaticallyTranslateClipboard
			.bind(to: SettingsService.shared.rx.isAutomaticallyTranslateClipboard)
			.disposed(by: disposeBag)
		shortcutToggleApp
			.bind(to: SettingsService.shared.rx.toggleAppShortcut)
			.disposed(by: disposeBag)
	}

	private func updateSettings() {
		let appDelegate = NSApplication.shared.delegate as! AppDelegate

		isShowIconInDock
			.debounce(0.3, scheduler: MainScheduler.asyncInstance)
			.map { value -> NSApplication.ActivationPolicy in
				value ? .regular : .accessory
			}
			.subscribe(onNext: { policy in
				NSApplication.shared.setActivationPolicy(policy)
			})
			.disposed(by: disposeBag)

		shortcutToggleApp.subscribe(onNext: { keyCombo in
			if let combo = keyCombo {
				appDelegate.toggleAppHotKey = HotKey(identifier: "SomeStuff", keyCombo: combo)
				appDelegate.toggleAppHotKey?.action = #selector(AppDelegate.togglePopoverFromMenuBar)
				appDelegate.toggleAppHotKey?.register()
			} else {
				appDelegate.toggleAppHotKey?.unregister()
				appDelegate.toggleAppHotKey = nil
			}
		})
		.disposed(by: disposeBag)
	}
}
