//
//  TranslateBarTests.swift
//  Translate BarTests
//
//  Created by Artem Bobrov on 09.06.2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import XCTest

import Moya
import EVReflection

@testable import Translate_Bar

class TranslateBarTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

	func testTranslationPreferencesParsing() {
		let json =
"""
{
	"dirs" : [
		"en-ru", "ru-uk", "uk-en"
	],
	"langs" :  {
		"ru": "Русский",
		"en": "Английский",
		"uk": "Украинский"
	}
}
"""
		let pref = TranslationPreferences(json: json)
		XCTAssert(pref.languages.count > 0, "There must be several languages")
		XCTAssert(pref.directions.count > 0, "There must be several directions")
		XCTAssertEqual(pref.languages.count, 3)
		XCTAssertEqual(pref.directions.count, 3)
		XCTAssertEqual(pref.languages.first(where: {$0.shortName == "en"})!.fullName, "Английский")
		XCTAssertEqual(pref.directions[Language(shortName: "ru", fullName: "Русский")], [Language(shortName: "uk", fullName: "Украинский")])
	}

	func testDecodeTextParsing() {
		let json =
"""
{
    "code": 200,
    "lang": "en"
}
"""
		let shortName = EVReflection.dictionaryFromJson(json) as! [String: Any]
		let lang = Language(shortName: shortName["lang"] as! String)
		XCTAssertEqual(lang.shortName, "en")
		XCTAssertNil(lang.fullName)
	}

	func testDecodeTranslationParsing() {
		let json =
"""
{
    "code": 200,
    "lang": "en-ru",
    "text": [
        "Здравствуй, Мир!"
    ]
}
"""
		let object = Translation(json: json)
		XCTAssertEqual(object.from, Language(shortName: "en"))
		XCTAssertEqual(object.to, Language(shortName: "ru"))
		XCTAssertEqual(object.text, "Здравствуй, Мир!")
	}
}
