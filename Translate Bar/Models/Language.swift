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
    static let english = Language(shortName: "en", fullName: "английский")
    static let russian = Language(shortName: "ru", fullName: "русский")
    static let german = Language(shortName: "de", fullName: "немецкий")

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
	var message: String?

	override func propertyMapping() -> [(keyInObject: String?, keyInResource: String?)] {
		return [
			(keyInObject: "from", keyInResource: nil),
			(keyInObject: "to", keyInResource: nil),
			(keyInObject: "text", keyInResource: nil),
			(keyInObject: "code", keyInResource: nil),
			(keyInObject: "message", keyInResource: nil)
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
					Log.verbose("Decoding translation ended with string count \(String(describing: self.text?.count))")
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
                    Log.verbose("Decoding translation language ended with value \(self.from!.shortName)-\(self.to!.shortName)")
				},
				encodeConverter: { return nil }
			),
			(
				key: "code",
				decodeConverter: { value in
					guard let code = value as? Int else {
						Log.error("Unexpected response: \(String(describing: value))")
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
