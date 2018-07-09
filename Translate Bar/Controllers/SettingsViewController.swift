//
//  SettingsViewController.swift
//  Translate Bar
//
//  Created by abobrov on 02/07/2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa
import RxSwift
import RxCocoa
import ITSwitch
import KeyHolder
import Magnet

class SettingsViewController: ViewController {
    @IBOutlet weak var closeButton: NSButton!
    @IBOutlet weak var launchAtLoginSwitcher: ITSwitch!
    @IBOutlet weak var showInDockSwitcher: ITSwitch!
    @IBOutlet weak var translateFromClipboardSwitcher: ITSwitch!
	@IBOutlet weak var shortcutRecordView: RecordView!

    private let disposeBag = DisposeBag()
	let settingsVM = SettingsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        updateSettingUI()
        setupUI()
    }

	override func viewWillAppear() {
		super.viewWillAppear()
		updateSettingUI()
	}

	private func updateSettingUI() {
		let settings = SettingsService.shared
		launchAtLoginSwitcher.checked = settings.isLaunchedAtLogin
		showInDockSwitcher.checked = settings.isShowIconInDock
		translateFromClipboardSwitcher.checked = settings.isAutomaticallyTranslateClipboard
		shortcutRecordView.keyCombo = settings.toggleAppShortcut
	}

    private func setupUI() {
        let appDelegate = NSApplication.shared.delegate as! AppDelegate // swiftlint:disable:this force_cast
        closeButton.rx
            .controlEvent
            .map { appDelegate.translateViewController }
            .bind(to: appDelegate.popover.rx.contentViewController)
            .disposed(by: disposeBag)
        setupSettingsUI()
    }

    private func setupSettingsUI() {
        launchAtLoginSwitcher.rx
            .isChecked
            .bind(to: settingsVM.isLaunchedAtLogin)
            .disposed(by: disposeBag)
        showInDockSwitcher.rx
            .isChecked
            .bind(to: settingsVM.isShowIconInDock)
            .disposed(by: disposeBag)
        translateFromClipboardSwitcher.rx
            .isChecked
            .bind(to: settingsVM.isAutomaticallyTranslateClipboard)
            .disposed(by: disposeBag)
		shortcutRecordView.rx
			.keyCombo
			.map { $0.1 }
			.bind(to: settingsVM.shortcutToggleApp)
			.disposed(by: disposeBag)
    }
}
