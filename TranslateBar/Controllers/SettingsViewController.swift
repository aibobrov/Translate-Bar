//
//  SettingsViewController.swift
//  TranslateBar
//
//  Created by Artem Bobrov on 21/10/2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa

class SettingsViewController: NSViewController {
    weak var coordinator: AppCoordinator?

    convenience init(coordinator: AppCoordinator) {
        self.init()
        self.coordinator = coordinator
    }
}
