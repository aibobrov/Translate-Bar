//
//  PopoverCoordinator.swift
//  TranslateBar
//
//  Created by Artem Bobrov on 21/10/2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa

public enum AppStep: Step {
    case settings
    case translation
}

public typealias AppCoordinator = Coordinator<AppStep>

public final class PopoverCoordinator: Coordinator<AppStep> {
    weak var popover: NSPopover?
    private let store = ViewControllerStore()

    init(popover: NSPopover) {
        self.popover = popover
        super.init()
        store.save(makeTranslationsViewController())
        store.save(makeSettingsViewController())
    }

    public override func start() {
        navigate(to: .translation)
    }

    override func navigate(to step: AppStep) {
        switch step {
        case .settings:
            navigate(to: store.fetch(byType: SettingsViewController.self)!)
        case .translation:
            navigate(to: store.fetch(byType: TranslateViewController.self)!)
        }
    }

    private func navigate(to viewController: NSViewController) {
        popover?.contentViewController = viewController
    }

    private func makeTranslationsViewController() -> TranslateViewController {
        let viewController = TranslateViewController(coordinator: self)
        return viewController
    }

    private func makeSettingsViewController() -> SettingsViewController {
        let viewController = SettingsViewController(coordinator: self)
        return viewController
    }
}
