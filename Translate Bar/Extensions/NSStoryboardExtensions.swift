//
//  NSStoryboardExtensions.swift
//  Translate Bar
//
//  Created by Artem Bobrov on 10.06.2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa

extension NSStoryboard {
	static func instantiateController<T: NSViewController>(from storyboardName: String, withIdentifier identifier: String) -> T? {
		let storyBoard = NSStoryboard(name: NSStoryboard.Name(rawValue: storyboardName), bundle: nil)
		return storyBoard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: identifier)) as? T
	}
}
