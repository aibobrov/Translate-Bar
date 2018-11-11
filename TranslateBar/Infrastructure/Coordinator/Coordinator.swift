//
//  Coordinator.swift
//  TranslateBar
//
//  Created by Artem Bobrov on 21/10/2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa

public class Coordinator<StepType: Step> {
    func start() {}
    func navigate(to _: StepType) {}
}

public protocol Step {}

class ViewControllerStore {
    private var store: [String: NSViewController] = [:]

    func save<T: NSViewController>(_ viewController: T) {
        store[String(describing: T.self)] = viewController
    }

    func fetch<T: NSViewController>(byType _: T.Type) -> T? {
        return store[String(describing: T.self)] as? T
    }
}
