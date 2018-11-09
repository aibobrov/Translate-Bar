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
    public func items<DataSource: RxCollectionViewDataSourceType & NSCollectionViewDataSource,
                      O: ObservableType>(dataSource: DataSource) -> (_ source: O) -> Disposable where O.E == [DataSource.Element] {
        return { source in
            source.subscribe { [weak collectionView = self.base] event in
                guard let collectionView = collectionView else { return }
                dataSource.collectionView(collectionView, observedEvent: event)
            }
        }
    }

    public func items<E, O: ObservableType>(_ source: O)
        -> (_ factory: @escaping (RxCollectionViewDataSource<E>, NSCollectionView, IndexPath, E) -> NSCollectionViewItem)
        -> Disposable where O.E == [E] {
        return { cellFactory in
            let ds = RxCollectionViewDataSource<E>.proxy(for: self.base)
            ds.itemFactory = cellFactory
            return self.items(dataSource: ds)(source)
        }
    }
}

extension Reactive where Base: NSCollectionView {
    var delegate: RxCollectionViewDelegateProxy {
        return RxCollectionViewDelegateProxy.proxy(for: base)
    }

    public var itemSelected: ControlEvent<IndexPath> {
        let source = delegate.didSelectItems.map { $0.first! }
        return ControlEvent(events: source)
    }
}
