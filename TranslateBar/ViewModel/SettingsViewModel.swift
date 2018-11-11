//
//  SettingsViewModel.swift
//  TranslateBar
//
//  Created by Artem Bobrov on 11/11/2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Magnet
import RxCocoa
import RxSwift

final class SettingsViewModel: ViewModelType {
    private let disposeBag = DisposeBag()

    public var isShowIconInDock = BehaviorRelay<Bool>(value: false)
    public var isAutomaticallyTranslateClipboard = BehaviorRelay<Bool>(value: false)
    public var shortcutToggleApp = BehaviorRelay<KeyCombo?>(value: nil)

    init() {
        update()
        setupStoreBindings()
    }
}

extension SettingsViewModel {
    private func update() {
        let settings = Settings.shared
        isShowIconInDock.accept(settings.isShowIconInDock)
        isAutomaticallyTranslateClipboard.accept(settings.isAutomaticallyTranslateClipboard)
        shortcutToggleApp.accept(settings.toggleAppShortcut)
    }

    private func setupStoreBindings() {
        let showInDock = isShowIconInDock.skip(1)
        showInDock
            .bind(to: Settings.shared.rx.isShowIconInDock)
            .disposed(by: disposeBag)
        let translateClipboard = isAutomaticallyTranslateClipboard.skip(1)
        translateClipboard
            .bind(to: Settings.shared.rx.isAutomaticallyTranslateClipboard)
            .disposed(by: disposeBag)
        let shortcut = shortcutToggleApp.skip(1)
        shortcut
            .bind(to: Settings.shared.rx.toggleAppShortcut)
            .disposed(by: disposeBag)

        updateSettings(showInDock: showInDock,
                       translateClipboard: translateClipboard,
                       shortcut: shortcut)
    }

    private func updateSettings(showInDock: Observable<Bool>, translateClipboard _: Observable<Bool>, shortcut: Observable<KeyCombo?>) {
        showInDock
            .map { value -> NSApplication.ActivationPolicy in
                value ? .regular : .accessory
            }
            .subscribe(onNext: { policy in
                NSApplication.shared.setActivationPolicy(policy)
            })
            .disposed(by: disposeBag)
        shortcut
            .subscribe(onNext: { kombo in
                NSApplication.shared.appDelegate.setupToggleShortcut(with: kombo)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Public API

extension SettingsViewModel {
    struct Input {
        let closeButtonClicked: Driver<()>
    }

    struct Output {}

    func transform(input: Input) -> Output {
        input.closeButtonClicked
            .drive(onNext: { _ in
                NSApplication.shared.appDelegate.coordinator.navigate(to: .translation)
            })
            .disposed(by: disposeBag)
        return Output()
    }
}
