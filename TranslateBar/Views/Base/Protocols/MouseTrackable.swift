//
//  MouseTrackable.swift
//  TranslateBar
//
//  Created by abobrov on 13/08/2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa

protocol MouseTrackable: class {
    var mouseTrackingArea: NSTrackingArea? { get set }

    func addTrackingArea(with options: NSTrackingArea.Options)
    func removeTrackingArea()
}

extension MouseTrackable where Self: NSView {
    func addTrackingArea(with options: NSTrackingArea.Options) {
        mouseTrackingArea = NSTrackingArea(rect: bounds, options: options, owner: self, userInfo: nil)
        addTrackingArea(mouseTrackingArea!)
    }

    func removeTrackingArea() {
        guard let trackingArea = self.mouseTrackingArea else { return }
        removeTrackingArea(trackingArea)
        mouseTrackingArea = nil
    }
}

extension MouseTrackable where Self: NSCollectionViewItem {
    func addTrackingArea(with options: NSTrackingArea.Options) {
        mouseTrackingArea = NSTrackingArea(rect: view.bounds, options: options, owner: self, userInfo: nil)
        view.addTrackingArea(mouseTrackingArea!)
    }

    func removeTrackingArea() {
        guard let trackingArea = self.mouseTrackingArea else { return }
        view.removeTrackingArea(trackingArea)
        mouseTrackingArea = nil
    }
}
