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

struct TranslateViewModel {
	var inputText = BehaviorRelay<String?>(value: "")
	var outputText = BehaviorRelay<String?>(value: "")

}
