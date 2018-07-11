//
//  KeyHolderExtension+Rx.swift
//  Translate Bar
//
//  Created by Artem Bobrov on 07.07.2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import RxSwift
import RxCocoa
import KeyHolder
import Magnet

extension KeyCombo {

}

private class RxRecordViewDelegateProxy: DelegateProxy<RecordView, RecordViewDelegate>,
										 RecordViewDelegate,
										 DelegateProxyType {
	fileprivate var keyCombo = PublishSubject<(RecordView, KeyCombo)>()
	fileprivate var viewDidEndRecording = PublishSubject<RecordView>()
	fileprivate var viewDidClearShortcut = PublishSubject<RecordView>()

	static func registerKnownImplementations() {
		self.register { parent -> RxRecordViewDelegateProxy in
			RxRecordViewDelegateProxy(parentObject: parent)
		}
	}

	init(parentObject: RecordView) {
		super.init(parentObject: parentObject, delegateProxy: RxRecordViewDelegateProxy.self)
	}

	static func currentDelegate(for object: RecordView) -> RecordViewDelegate? {
		let recordView = object
		return recordView.delegate
	}

	static func setCurrentDelegate(_ delegate: RecordViewDelegate?, to object: RecordView) {
		let recordView = object
		recordView.delegate = delegate
	}

	func recordViewShouldBeginRecording(_ recordView: RecordView) -> Bool {
		return true
	}

	func recordView(_ recordView: RecordView, canRecordKeyCombo keyCombo: KeyCombo) -> Bool {
		return true
	}

	func recordViewDidClearShortcut(_ recordView: RecordView) {
		viewDidClearShortcut.onNext(recordView)
	}

	func recordView(_ recordView: RecordView, didChangeKeyCombo keyCombo: KeyCombo) {
		self.keyCombo.onNext((recordView, keyCombo))
	}

	func recordViewDidEndRecording(_ recordView: RecordView) {
		viewDidEndRecording.onNext(recordView)
	}

}

extension Reactive where Base: RecordView {
	fileprivate var delegateProxy: RxRecordViewDelegateProxy {
		return RxRecordViewDelegateProxy.proxy(for: self.base)
	}

	var keyCombo: Observable<KeyCombo> {
		return delegateProxy.keyCombo.map { $0.1 }.asObservable()
	}

	var didEndRecording: Observable<()> {
        return delegateProxy.viewDidEndRecording.map { _ in () }.asObservable()
	}

	var didClearShortcut: Observable<()> {
        return delegateProxy.viewDidClearShortcut.map { _ in () }.asObservable()
	}
}
