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
    func items<DataSource: RxTableViewDataSourceType & NSTableViewCoordinator,
               O: ObservableType>(dataSource: DataSource) -> (_ source: O) -> Disposable where O.E == [DataSource.Element] {
        return { source in
            source.subscribe { [weak tableView = self.base] event in
                guard let tableView = tableView else { return }
                dataSource.tableView(tableView, observedEvent: event)
            }
        }
    }

    func items<E, O: ObservableType>(_ source: O)
        -> (_ factory: @escaping (RxTableViewDataSource<E>, NSTableView, Int, E) -> NSView?)
        -> Disposable where O.E == [E] {
        return { cellFactory in
            let ds = RxTableViewDataSource<E>.proxy(for: self.base)
            ds.viewFactory = cellFactory
            return self.items(dataSource: ds)(source)
        }
    }
}
