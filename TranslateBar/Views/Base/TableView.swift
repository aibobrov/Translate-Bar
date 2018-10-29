//
//  TableView.swift
//  TranslateBar
//
//  Created by abobrov on 09/08/2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa
import RxCocoa
import RxSwift

class TableView: NSTableView {
    public let dataReloaded = PublishSubject<()>()
    public let cellSizeChanged = PublishSubject<NSTableCellView>()

    override func reloadData() {
        super.reloadData()
        dataReloaded.onNext(())
    }

    deinit {
        dataReloaded.onCompleted()
    }
}

protocol Customizable where Self: NSTableCellView {
    associatedtype DataType

    func setup(with data: DataType, for row: Int)
}
