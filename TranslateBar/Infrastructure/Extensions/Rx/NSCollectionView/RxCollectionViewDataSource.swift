//
//  RxCollectionViewDataSource.swift
//  Pods-RxNSDataSources_Example
//
//  Created by Artem Bobrov on 29.07.2018.
//

import Cocoa

open class RxCollectionViewDataSource<E>: NSObject, NSCollectionViewDataSource {
    public typealias CollectionItemFactory<E> = (RxCollectionViewDataSource<E>, NSCollectionView, IndexPath, E) -> NSCollectionViewItem
    public typealias CollectionItemConfig<E, ItemType: NSCollectionViewItem> = (ItemType, IndexPath, E) -> Void

    public private(set) var items: [E] = []

    public var collectionView: NSCollectionView?

    public let itemIdentifier: String
    public let itemFactory: CollectionItemFactory<E>

    public weak var delegate: NSCollectionViewDelegate?
    public weak var dataSource: NSCollectionViewDataSource?

    public init(itemIdentifier: String, itemFactory: @escaping CollectionItemFactory<E>) {
        self.itemIdentifier = itemIdentifier
        self.itemFactory = itemFactory
    }

    public init<ItemType>(itemIdentifier: String, itemType: ItemType.Type, itemConfig: @escaping CollectionItemConfig<E, ItemType>) where ItemType: NSCollectionViewItem {
        self.itemIdentifier = itemIdentifier
        itemFactory = { _, cv, ip, model in
            let item = cv.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: itemIdentifier), for: ip) as! ItemType // swiftlint:disable:this force_cast
            itemConfig(item, ip, model)
            return item
        }
    }

    public func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    public func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        return itemFactory(self, collectionView, indexPath, items[indexPath.item])
    }

    open override func responds(to aSelector: Selector!) -> Bool {
        if RxCollectionViewDataSource.instancesRespond(to: aSelector) {
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
        guard let collectionView = collectionView else { return }
        self.items = items
        collectionView.reloadData()
    }
}
