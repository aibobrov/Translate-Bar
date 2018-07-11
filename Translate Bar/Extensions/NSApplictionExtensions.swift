//
//  NSApplictionExtensions.swift
//  Translate Bar
//
//  Created by Artem Bobrov on 11.07.2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa

extension NSApplication {
	var appDelegate: AppDelegate {
		return NSApplication.shared.delegate as! AppDelegate // swiftlint:disable:this force_cast
	}
}
