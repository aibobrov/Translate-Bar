//
//  RxCollectionViewDelegateProxy.swift
//  Translate Bar
//
//  Created by Artem Bobrov on 30/10/2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa
import RxCocoa
import RxSwift

open class RxCollectionViewDelegateProxy: DelegateProxy<NSCollectionView, NSCollectionViewDelegate>,
    DelegateProxyType,
    NSCollectionViewDelegate {
    public weak var collectionView: NSCollectionView?
    public var didSelectItems = PublishSubject<Set<IndexPath>>()
    public static func registerKnownImplementations() {
        register(make: { RxCollectionViewDelegateProxy(collectionView: $0) })
    }

    public static func currentDelegate(for object: NSCollectionView) -> NSCollectionViewDelegate? {
        return object.delegate
    }

    public static func setCurrentDelegate(_ delegate: NSCollectionViewDelegate?, to object: NSCollectionView) {
        object.delegate = delegate
    }

    public init(collectionView: ParentObject) {
        self.collectionView = collectionView
        super.init(parentObject: collectionView, delegateProxy: RxCollectionViewDelegateProxy.self)
    }

    public func collectionView(_: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        didSelectItems.on(.next(indexPaths))
    }

    deinit {
        didSelectItems.onCompleted()
    }
}
