//
//  LimitedTextView.swift
//  Translate Bar
//
//  Created by Artem Bobrov on 18.06.2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa

class LimitedTextView: TextView, NSTextViewDelegate {
	@IBInspectable
	var maxCharactersCount: Int = .max

	override init(frame frameRect: NSRect) {
		super.init(frame: frameRect)
		setup()
	}

	override init(frame frameRect: NSRect, textContainer container: NSTextContainer?) {
		super.init(frame: frameRect, textContainer: container)
		setup()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setup()
	}

	private func setup() {
		self.delegate = self
	}

	func textView(_ textView: NSTextView, shouldChangeTextIn affectedCharRange: NSRange, replacementString: String?) -> Bool {
		let text = textView.string
		guard let stringRange = Range(affectedCharRange, in: text) else { return false }
		let updatedText = text.replacingCharacters(in: stringRange, with: replacementString ?? "")
		return updatedText.count <= self.maxCharactersCount
	}

}
