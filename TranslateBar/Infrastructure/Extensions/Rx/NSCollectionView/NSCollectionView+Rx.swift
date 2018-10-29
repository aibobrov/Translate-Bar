//
//  NSCollectionView+Rx.swift
//  Pods-RxNSDataSources_Example
//
//  Created by Artem Bobrov on 29.07.2018.
//

import Cocoa
import RxCocoa
import RxSwift

extension Reactive where Base: NSCollectionView {
    public func dataChanges<E>(_ dataSource: RxCollectionViewDataSource<E>) -> Binder<[E]> {
        dataSource.collectionView = base
        base.dataSource = dataSource
        return Binder(base) { _, items in
            dataSource.applyChanges(items: items)
        }
    }

    public var itemSelected: ControlEvent<IndexPath> {
        let source = base.rx
            .methodInvoked(#selector(NSCollectionViewDelegate.collectionView(_:didSelectItemsAt:)))
            .map { $0[1] as! Set<IndexPath> } // swiftlint:disable:this force_cast
            .map { $0.first! } // swiftlint:disable:this force_cast
        return ControlEvent(events: source)
    }
}
