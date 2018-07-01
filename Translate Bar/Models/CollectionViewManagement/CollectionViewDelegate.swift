//
//  CollectionViewDelegate.swift
//  Translate Bar
//
//  Created by Artem Bobrov on 30.06.2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa

protocol CollectionViewDelegateProtocol: class where Self: NSCollectionViewDelegate {
	associatedtype Data: Collection where Data.Index == Int
	associatedtype Cell: NSCollectionViewItem

	func onCollectionItemClicked(_ handler: @escaping (Cell, IndexPath, Data.Element?) -> Void)
}

class CollectionViewDelegate<DataType: Collection, CellType: NSCollectionViewItem>: NSObject, CollectionViewDelegateProtocol, NSCollectionViewDelegate where DataType.Index == Int {
	typealias Data = DataType
	typealias Cell = CellType
	private var collectionItemClickedHandler: ((Cell, IndexPath, Data.Element?) -> Void)?

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
		collectionItemClickedHandler?(cell, indexPath, nil)
	}

}
