//
//  TranslateViewController.swift
//  Translate Bar
//
//  Created by Artem Bobrov on 13.06.2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa
import RxCocoa
import RxSwift

class TranslateViewController: NSViewController {
	@IBOutlet var InputTextView: NSTextView!
	@IBOutlet var OutputTextView: NSTextView!

	let translateVM = TranslateViewModel()
	private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
//		InputTextView.rx.text
//			.filter({$0 != nil && $0!.count > 0})
//			.map({$0!})
//			.debounce(1, scheduler: MainScheduler.instance)
//			.bind(to: translateVM.inputText)
//			.disposed(by: disposeBag)
//
//		translateVM.outputText
//			.bind(to: OutputTextView.rx.text)
//			.disposed(by: disposeBag)
    }
}
