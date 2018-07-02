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

class SettingsViewController: NSViewController {
    @IBOutlet weak var closeButton: NSButton!

    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        closeButton.rx
            .controlEvent
            .subscribe(onNext: { _ in
                self.showMain()
            })
            .disposed(by: disposeBag)
    }

    private func showMain() {
        let appDelegate = NSApplication.shared.delegate as! AppDelegate // swiftlint:disable:this force_cast
        appDelegate.popover.contentViewController = appDelegate.translateViewController
    }
}
