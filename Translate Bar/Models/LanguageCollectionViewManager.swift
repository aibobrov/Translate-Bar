//
//  LanguageCollectionViewManager.swift
//  Translate Bar
//
//  Created by Artem Bobrov on 01.07.2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa
import RxCocoa
import RxSwift

typealias LanguageCollectionViewManager = CollectionViewManager<[Language], LanguageCollectionViewItem>

extension Reactive where Base: LanguageCollectionViewManager {
	var selectedItem: Observable<(LanguageCollectionViewManager.Data.Element, IndexPath, LanguageCollectionViewManager.Cell)> {
		return base.rx
			.sentMessage(#selector(LanguageCollectionViewManager.collectionView(_:didSelectItemsAt:)))
			.map { args -> (NSCollectionView, Set<IndexPath>) in
				let collectionView = args[0] as! NSCollectionView // swiftlint:disable:this force_cast
				let indexPaths = args[1] as! Set<IndexPath> // swiftlint:disable:this force_cast
				return (collectionView, indexPaths)
			}
			.filter { $0.1.count == 1 }
			.map { (collectionView, indexPaths) in
				let indexPath = indexPaths.first!
				let cell = collectionView.item(at: indexPath) as! LanguageCollectionViewManager.Cell // swiftlint:disable:this force_cast
				let item = self.base.items[indexPath.item] // swiftlint:disable:this force_cast
				return (item, indexPath, cell)
			}
	}
}
