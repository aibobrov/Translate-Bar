//
//  TableCellViewAction.swift
//  TranslateBar
//
//  Created by Artem Bobrov on 11/11/2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa

class TableCellViewAction<Object> {
    let notification: NSNotification.Name
    init(_ notification: NSNotification.Name) {
        self.notification = notification
    }

    public func invoke(on _: NSTableCellView?, object: Object?) {
        let center = NotificationCenter.default
        center.post(name: notification, object: object)
    }
}
