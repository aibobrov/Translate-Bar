//
//  SettingsViewController.swift
//  TranslateBar
//
//  Created by Artem Bobrov on 21/10/2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa
import RxSwift

class SettingsViewController: NSViewController {
    @IBOutlet var settingsView: SettingsView!

    weak var coordinator: AppCoordinator?
    private let disposeBag = DisposeBag()
    private let viewModel = SettingsViewModel()
    convenience init(coordinator: AppCoordinator) {
        self.init()
        self.coordinator = coordinator
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let input = SettingsViewModel.Input(closeButtonClicked: settingsView.closeButton.rx.tap.asDriver())
        _ = viewModel.transform(input: input)
        setupBindings()
    }

    private func setupBindings() {
        (settingsView.showInDockSwitcher.rx.isChecked <-> viewModel.isShowIconInDock).disposed(by: disposeBag)
        (settingsView.translateFromClipboardSwitcher.rx.isChecked <-> viewModel.isAutomaticallyTranslateClipboard).disposed(by: disposeBag)
        (settingsView.shortcutRecordView.rx.keyCombo <-> viewModel.shortcutToggleApp).disposed(by: disposeBag)
    }
}
