//
//  NSTableView+Rx.swift
//  TranslateBar
//
//  Created by Artem Bobrov on 04.08.2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa
import RxCocoa
import RxSwift

extension Reactive where Base: NSTableView {
    public func dataChanges<E>(_ dataSource: RxTableViewDataSource<E>) -> Binder<[E]> {
        dataSource.tableView = base
        base.dataSource = dataSource
        base.delegate = dataSource
        return Binder(base) { _, items in
            dataSource.applyChanges(items: items)
        }
    }
}
