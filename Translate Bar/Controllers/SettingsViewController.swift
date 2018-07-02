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

class SettingsViewController: NSViewController {
    @IBOutlet weak var closeButton: NSButton!
    @IBOutlet weak var launchAtLoginSwitcher: ITSwitch!
    @IBOutlet weak var showInDockSwitcher: ITSwitch!
    @IBOutlet weak var translateFromClipboardSwitcher: ITSwitch!

    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
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
            .bind(to: SettingsService.shared.rx.isLaunchedAtLogin)
            .disposed(by: disposeBag)
        showInDockSwitcher.rx
            .isChecked
            .bind(to: SettingsService.shared.rx.isShowIconInDock)
            .disposed(by: disposeBag)
        translateFromClipboardSwitcher.rx
            .isChecked
            .bind(to: SettingsService.shared.rx.isAutomaticallyTranslateClipboard)
            .disposed(by: disposeBag)
    }
}
