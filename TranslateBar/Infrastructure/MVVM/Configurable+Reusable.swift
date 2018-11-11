//
//  Configurable+Reusable.swift
//  TranslateBar
//
//  Created by Artem Bobrov on 10/11/2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa

protocol Configurable {
    associatedtype DataType

    func configure(with _: DataType)
}

protocol Reusable {
    static var identifier: NSUserInterfaceItemIdentifier { get }
}

extension Reusable {
    static var identifier: NSUserInterfaceItemIdentifier {
        return NSUserInterfaceItemIdentifier(String(describing: self))
    }
}

extension NSCollectionViewItem: Reusable {}
extension NSTableCellView: Reusable {}

extension NSTableView {
    func makeView<T: NSTableCellView>(ofType: T.Type) -> T {
        return makeView(withIdentifier: T.identifier, owner: self) as! T // swiftlint:disable:this force_cast
    }
}

extension NSCollectionView {
    func makeItem<T: NSCollectionViewItem>(ofType: T.Type, for indexPath: IndexPath) -> T {
        return makeItem(withIdentifier: T.identifier, for: indexPath) as! T // swiftlint:disable:this force_cast
    }
}
