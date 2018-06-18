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
	var inputText = BehaviorRelay<String?>(value: nil)
	var outputText = BehaviorRelay<String?>(value: nil)

	private let translateProvider = MoyaProvider<YandexTranslate>()

	init() {
		inputText
            .filter({$0 != nil && $0!.count > 0})
            .map({$0!})
            .debounce(1, scheduler: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
			.subscribe(onNext: { [unowned self] value in
                self.translateProvider
                    .rx
					.request(.translate(from: Language(shortName: "ru"), to: Language(shortName: "en"), text: value),
							 callbackQueue: DispatchQueue.global(qos: .userInteractive)).Rmap(to: Translation.self)
					.filter({ $0.text != nil })
					.subscribe(onSuccess: { translation in
						self.outputText.accept(translation.text!)
                    }, onError: { (error) in
                        self.outputText.accept("")
                        Log.error(error.localizedDescription)
                    })
                    .disposed(by: self.disposeBag)
			}, onError: { error in
                self.outputText.accept("")
				Log.error(error.localizedDescription)
			}, onCompleted: {
                self.outputText.accept("")
				Log.verbose("Completed inputText sequence")
			},
            onDisposed: {
                self.outputText.accept("")
                Log.verbose("Disposed inputText sequence")
            })
			.disposed(by: disposeBag)
	}
}
