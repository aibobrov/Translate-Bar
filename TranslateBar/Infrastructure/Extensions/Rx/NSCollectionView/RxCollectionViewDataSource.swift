//
//  RxCollectionViewDataSource.swift
//  Pods-RxNSDataSources_Example
//
//  Created by Artem Bobrov on 29.07.2018.
//

import Cocoa
import RxCocoa
import RxSwift

extension NSCollectionView: HasDelegate, HasDataSource {}

public protocol RxCollectionViewDataSourceType {
    associatedtype Element
    func collectionView(_ collectionView: NSCollectionView, observedEvent: Event<[Element]>)
}

open class RxCollectionViewDataSource<E>:
    DelegateProxy<NSCollectionView, NSCollectionViewDataSource>,
    DelegateProxyType,
    RxCollectionViewDataSourceType,
    NSCollectionViewDataSource {
    public func collectionView(_ collectionView: NSCollectionView, observedEvent: Event<[E]>) {
        Binder(self) { _, items in
            self.applyChanges(items: items)
        }.on(observedEvent)
    }

    public typealias Element = E
    public static func registerKnownImplementations() {
        register(make: { RxCollectionViewDataSource<E>(parentObject: $0) })
    }

    public typealias CollectionItemFactory<E> = (RxCollectionViewDataSource<E>, NSCollectionView, IndexPath, E) -> NSCollectionViewItem
    public typealias CollectionItemConfig<E, ItemType: NSCollectionViewItem> = (ItemType, IndexPath, E) -> Void

    public private(set) var items: [E] = []

    public weak var collectionView: NSCollectionView?

    public var itemFactory: CollectionItemFactory<E>!

    internal init(parentObject: NSCollectionView) {
        collectionView = parentObject
        super.init(parentObject: parentObject, delegateProxy: RxCollectionViewDataSource<E>.self)
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

    func applyChanges(items: [E]) {
        guard let collectionView = collectionView else { return }
        self.items = items
        collectionView.reloadData()
    }
}
