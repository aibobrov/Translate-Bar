//
//  RxTableViewDataSource.swift
//  TranslateBar
//
//  Created by Artem Bobrov on 04.08.2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa

open class RxTableViewDataSource<E>: NSObject, NSTableViewDataSource, NSTableViewDelegate {
    public typealias TableViewFactory<E> = (RxTableViewDataSource<E>, NSTableView, Int, E) -> NSView?
    public typealias TableViewConfig<E, ViewType: NSTableCellView> = (ViewType, Int, E) -> Void

    public private(set) var items: [E] = []

    public var tableView: NSTableView?

    public let viewIdentifier: String
    public let viewFactory: TableViewFactory<E>

    public weak var delegate: NSTableViewDelegate?
    public weak var dataSource: NSTableViewDataSource?

    public init(viewIdentifier: String, viewFactory: @escaping TableViewFactory<E>) {
        self.viewIdentifier = viewIdentifier
        self.viewFactory = viewFactory
    }

    public init<ViewType>(viewIdentifier: String, viewType: ViewType.Type, viewConfig: @escaping TableViewConfig<E, ViewType>) where ViewType: NSTableCellView {
        self.viewIdentifier = viewIdentifier
        viewFactory = { ds, tv, ip, model in
            let view = tv.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: viewIdentifier), owner: ds) as! ViewType // swiftlint:disable:this force_cast
            viewConfig(view, ip, model)
            return view
        }
    }

    public func numberOfRows(in tableView: NSTableView) -> Int {
        return items.count
    }

    public func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        return viewFactory(self, tableView, row, items[row])
    }

    open override func responds(to aSelector: Selector!) -> Bool {
        if RxTableViewDataSource.instancesRespond(to: aSelector) {
            return true
        } else if let delegate = delegate {
            return delegate.responds(to: aSelector)
        } else if let dataSource = dataSource {
            return dataSource.responds(to: aSelector)
        } else {
            return false
        }
    }

    open override func forwardingTarget(for aSelector: Selector!) -> Any? {
        return delegate ?? dataSource
    }

    func applyChanges(items: [E]) {
        guard let tableView = tableView else { return }
        self.items = items
        tableView.reloadData()
    }
}
