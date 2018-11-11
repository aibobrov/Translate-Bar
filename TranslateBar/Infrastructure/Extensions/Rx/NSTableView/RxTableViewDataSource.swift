//
//  RxTableViewDataSource.swift
//  TranslateBar
//
//  Created by Artem Bobrov on 04.08.2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa
import RxCocoa
import RxSwift

typealias NSTableViewCoordinator = NSTableViewDelegate & NSTableViewDataSource

extension NSTableView: HasDelegate {}

fileprivate extension NSTableView {
    var coordinator: NSTableViewCoordinator? {
        get {
            return delegate as? NSTableViewCoordinator ?? dataSource as? NSTableViewCoordinator
        }
        set {
            delegate = newValue
            dataSource = newValue
        }
    }
}

public protocol RxTableViewDataSourceType {
    associatedtype Element
    func tableView(_ tableView: NSTableView, observedEvent: Event<[Element]>)
}

class RxTableViewDataSource<E>:
    DelegateProxy<NSTableView, NSTableViewCoordinator>,
    DelegateProxyType,
    RxTableViewDataSourceType, NSTableViewCoordinator {
    public typealias TableViewFactory<E> = (RxTableViewDataSource<E>, NSTableView, Int, E) -> NSView?

    public typealias Element = E
    public static func registerKnownImplementations() {
        register(make: { RxTableViewDataSource<E>(parentObject: $0) })
    }

    public static func currentDelegate(for object: NSTableView) -> NSTableViewCoordinator? {
        return object.coordinator
    }

    public static func setCurrentDelegate(_ delegate: NSTableViewCoordinator?, to object: NSTableView) {
        object.coordinator = delegate
    }

    public private(set) var items: [E] = []
    public var viewFactory: TableViewFactory<E>!

    init(parentObject: NSTableView) {
        super.init(parentObject: parentObject, delegateProxy: RxTableViewDataSource<E>.self)
    }

    func applyChanges(_ tableView: NSTableView, items: [E]) {
        self.items = items
        tableView.reloadData()
    }

    func tableView(_ tableView: NSTableView, observedEvent: Event<[E]>) {
        Binder(self) { ds, items in
            ds.applyChanges(tableView, items: items)
        }.on(observedEvent)
    }

    func numberOfRows(in _: NSTableView) -> Int {
        return items.count
    }

    func tableView(_ tableView: NSTableView, viewFor _: NSTableColumn?, row: Int) -> NSView? {
        return viewFactory(self, tableView, row, items[row])
    }
}
