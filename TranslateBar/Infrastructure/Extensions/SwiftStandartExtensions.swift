//
//  SwiftStandartExtensions.swift
//
//
//  Created by Artem Bobrov on 01.07.2018.
//

import Foundation

extension String {
    var lettersCount: Int {
        return unicodeScalars.filter { CharacterSet.letters.contains($0) }.count
    }
}

extension String {
    var words: [String] {
        let regex = "\\w+"
        let expression = try! NSRegularExpression(pattern: regex, options: .caseInsensitive) // swiftlint:disable:this force_try

        let results = expression.matches(in: self, options: NSRegularExpression.MatchingOptions.withTransparentBounds, range: NSRange(location: 0, length: count))
        return results.map {
            String(self[Range($0.range, in: self)!])
        }
    }
}
