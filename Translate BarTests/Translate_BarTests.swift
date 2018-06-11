//
//  Translate_BarTests.swift
//  Translate BarTests
//
//  Created by Artem Bobrov on 09.06.2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import XCTest

import Moya
import EVReflection

@testable import Translate_Bar

class Translate_BarTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

	func testTranslationPreferences() {
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
}
