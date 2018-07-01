//
//  CollectionViewManager.swift
//  Translate Bar
//
//  Created by Artem Bobrov on 01.07.2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa
import RxCocoa
import RxSwift

class CollectionViewManager<DataType: Collection, CellType: NSCollectionViewItem>:
	NSObject,
	NSCollectionViewDataSource,
	CollectionViewDataSourceProtocol,
	NSCollectionViewDelegate,
CollectionViewDelegateProtocol where DataType.Index == Int {
	typealias Data = DataType
	typealias Cell = CellType

	var items: Data
	var identifier: String
	var configureHandler: (Data.Element, Int, Cell) -> Void
	private var collectionItemClickedHandler: ((Cell, IndexPath, Data.Element?) -> Void)?

	required init(identifier: String, items: Data, configure: @escaping (Data.Element, Int, Cell) -> Void) {
		self.identifier = identifier
		self.items = items
		self.configureHandler = configure
	}

	// MARK: - CollectionViewDataSourceProtocol implementation
	func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
		return items.count
	}

	func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
		let cell = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(identifier), for: indexPath) as! Cell // swiftlint:disable:this force_cast
		let item = items[indexPath.item]
		configureHandler(item, indexPath.item, cell)
		return cell
	}

	// MARK: - CollectionViewDelegateProtocol implementation
	func onCollectionItemClicked(_ handler: @escaping (Cell, IndexPath, Data.Element?) -> Void) {
		collectionItemClickedHandler = handler
	}

	func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
		guard indexPaths.count == 1,
			let indexPath = indexPaths.first else {
				Log.warning("Unable to get indexPath of selected item, \(indexPaths)")
				return
		}
		let cell = collectionView.item(at: indexPath) as! Cell // swiftlint:disable:this force_cast
		let item = items[indexPath.item]
		collectionItemClickedHandler?(cell, indexPath, item)
	}
}
