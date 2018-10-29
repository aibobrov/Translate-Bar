//
//  ViewModelType.swift
//
//
//  Created by Artem Bobrov on 02/10/2018.
//

import Foundation

public protocol ViewModelType {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}
