//
//  TranslateViewModel.swift
//  Translate Bar
//
//  Created by Artem Bobrov on 13.06.2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

class TranslateViewModel {
	private let disposeBag = DisposeBag()
	var inputText = BehaviorRelay<String>(value: "")
	var outputText = BehaviorRelay<String>(value: "")

	let translateProvider = MoyaProvider<YandexTranslate>()

	init() {
		inputText.subscribe(onNext: { [unowned self] value in
			self.translateProvider
				.rx
				.request(.translate(from: Language(shortName: "ru"), to: Language(shortName: "en"), text: value),
						 callbackQueue: DispatchQueue.global(qos: .userInteractive)).Rmap(to: Translation.self)
				.filter({ $0.text != nil })
				.subscribe(onSuccess: { translation in
					self.outputText.accept(translation.text!)
				}, onError: { (error) in
					Log.error(error.localizedDescription)
				})
				.disposed(by: self.disposeBag)
		}, onError: { error in
			Log.error(error.localizedDescription)
		}, onCompleted: {
			Log.verbose("Completed inputText sequence")
		},
		   onDisposed: nil)
		.disposed(by: disposeBag)
	}
}
