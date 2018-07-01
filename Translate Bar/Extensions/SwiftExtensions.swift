//
//  SwiftExtensions.swift
//  
//
//  Created by Artem Bobrov on 01.07.2018.
//

import Foundation

extension String {
	var letterCount: Int {
		return unicodeScalars.filter({ CharacterSet.letters.contains($0) }).count
	}

	var digitCount: Int {
		return unicodeScalars.filter({ CharacterSet.decimalDigits.contains($0) }).count
	}
}
