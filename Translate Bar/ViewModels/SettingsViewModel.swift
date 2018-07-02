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

class SettingsViewModel {
	private let disposeBag = DisposeBag()

	var isLaunchedAtLogin = BehaviorRelay<Bool>(value: false)
	var isShowIconInDock = BehaviorRelay<Bool>(value: false)
	var isAutomaticallyTranslateClipboard = BehaviorRelay<Bool>(value: false)
	init() {
		setupStoreBindings()
		setupActions()
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
	}

	private func setupActions() {
		isShowIconInDock
			.debounce(0.3, scheduler: MainScheduler.asyncInstance)
			.map { value -> NSApplication.ActivationPolicy in
				value ? .regular : .accessory
			}
			.subscribe(onNext: { policy in
				NSApplication.shared.setActivationPolicy(policy)
			})
			.disposed(by: disposeBag)
	}
}
