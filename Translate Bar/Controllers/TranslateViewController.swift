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
	@IBOutlet weak var InputTextView: NSTextView!
	@IBOutlet weak var OutputTextView: NSTextView!
    @IBOutlet weak var TextHeightConstraint: NSLayoutConstraint!

	let translateVM = TranslateViewModel()
	private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        InputTextView.rx.text
            .bind(to: translateVM.inputText)
            .disposed(by: disposeBag)
        InputTextView.rx.text
            .subscribe { [unowned self] _ in
               self.resizeAccordingToContent()
            }
            .disposed(by: disposeBag)

        translateVM.outputText
            .bind(to: OutputTextView.rx.text)
            .disposed(by: disposeBag)
        translateVM.outputText
            .subscribe { [unowned self] _ in
                self.resizeAccordingToContent()
            }
            .disposed(by: disposeBag)
    }

    private func resizeAccordingToContent() {
        let maxTextHeight = max(self.InputTextView.intrinsicContentSize.height, self.OutputTextView.intrinsicContentSize.height) + 16
        let screenHeight = NSScreen.main?.frame.height ?? 0
        self.TextHeightConstraint.constant = max(200, maxTextHeight)
        let appDelegate = NSApplication.shared.delegate as! AppDelegate // swiftlint:disable:this force_cast
        appDelegate.popover.contentSize.height = min(appDelegate.popover.contentSize.height, screenHeight)
    }
}
