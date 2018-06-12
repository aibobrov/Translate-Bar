//
//  Language.swift
//  Translate Bar
//
//  Created by Artem Bobrov on 11.06.2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Foundation
import EVReflection

class Language: Hashable {

	var shortName: String = ""
	var fullName: String?

	init(shortName: String, fullName: String? = nil) {
		self.shortName = shortName
		self.fullName = fullName
	}

	static func == (lhs: Language, rhs: Language) -> Bool {
		return lhs.fullName == rhs.fullName && lhs.shortName == rhs.shortName
	}

	var hashValue: Int {
		return shortName.hashValue
	}
}

class Translation: EVObject {
	var from: Language?
	var to: Language?
	var text: String?

	override func propertyMapping() -> [(keyInObject: String?, keyInResource: String?)] {
		return [
			(keyInObject: "from", keyInResource: nil),
			(keyInObject: "to", keyInResource: nil),
			(keyInObject: "text", keyInResource: nil),
			(keyInObject: "code", keyInResource: nil)
		]
	}

	override func propertyConverters() -> [(key: String, decodeConverter: ((Any?) -> Void), encodeConverter: (() -> Any?))] {
		return [
			(
				key: "text",
				decodeConverter: { value in
					guard let translation = value as? [String] else {
						Log.error("Unexpected translation result: \(String(describing: value))")
						return
					}
					self.text = translation.first
					Log.verbose("Decoding translation END")
				},
				encodeConverter: { return nil }
			),
			(
				key: "lang",
				decodeConverter: { value in
					guard let translation = value as? String else {
						Log.error("Unexpected translation language result: \(String(describing: value))")
						return
					}
					let langs = translation.split(separator: "-")
					self.from = Language(shortName: String(langs.first!))
					self.to = Language(shortName: String(langs.last!))
					Log.verbose("Decoding translation language END")
				},
				encodeConverter: { return nil }
			),
			(
				key: "code",
				decodeConverter: { value in
					guard let code = value as? Int else {
						Log.error("Unexpected code response: \(String(describing: value))")
						return
					}
					if code != 200 {
						Log.error("Unexpected response code")
					}
				},
				encodeConverter: { return nil }
			)

		]
	}
}
