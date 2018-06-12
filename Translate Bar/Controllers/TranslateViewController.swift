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

	@IBOutlet var inputTextView: NSTextView!
	@IBOutlet var outputTextView: NSTextView!

	let translateVM = TranslateViewModel()
	let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
		inputTextView.rx.text.bind(to: translateVM.inputText)
		translateVM.inputText.asObservable().subscribe { (event) in
			print("translateVM \(event)")
		}
    }
    
}
