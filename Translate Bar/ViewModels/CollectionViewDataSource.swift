//
//  CollectionViewDataSource.swift
//  Translate Bar
//
//  Created by abobrov on 29/06/2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa

protocol CollectionViewDataSourceProtocol: NSCollectionViewDataSource {
    associatedtype Data: Collection where Data.Index == Int
    associatedtype Cell: NSCollectionViewItem

    var identifier: String { get }
    var items: Data { get set }
    var configure: (Data.Element, Int, Cell) -> Void { get set }

    func onCollectionItemClicked(_ handler: @escaping (Cell, IndexPath) -> Void)
}

class CollectionViewDataSource<DataType: Collection, CellType: NSCollectionViewItem>: NSObject, CollectionViewDataSourceProtocol where DataType.Index == Int {
    typealias Data = DataType
    typealias Cell = CellType

    var items: DataType
    var identifier: String
    var configure: (DataType.Element, Int, CellType) -> Void
    private var collectionItemClickedHandler: ((CellType, IndexPath) -> Void)?
    init(identifier: String, items: DataType, configure: @escaping (DataType.Element, Int, CellType) -> Void) {
        self.identifier = identifier
        self.items = items
        self.configure = configure
    }

    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let cell = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(identifier), for: indexPath) as! Cell // swiftlint:disable:this force_cast
        let item = items[indexPath.item]
        configure(item, indexPath.item, cell)
        return cell
    }

    func onCollectionItemClicked(_ handler:  @escaping (CellType, IndexPath) -> Void) {
        self.collectionItemClickedHandler = handler
    }
}
