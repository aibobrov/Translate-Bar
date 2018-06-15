//
//  SidedRoundedSegmentedCell.swift
//  Translate Bar
//
//  Created by Artem Bobrov on 15.06.2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa

class LeftSideRoundedSegmentedCell: CustomRoundedSegmentCell {
	override func path(for segment: Int, in rect: NSRect) -> NSBezierPath {
		switch segment {
		case 0:
			return HalfRoundedBezierPath.path(for: .left, in: rect, with: cornerRadius)
		default:
			return NSBezierPath(rect: rect)
		}
	}
}

class RightSideRoundedSegmentedCell: CustomRoundedSegmentCell {
	override func path(for segment: Int, in rect: NSRect) -> NSBezierPath {
		switch segment {
		case segmentCount - 1:
			return HalfRoundedBezierPath.path(for: .right, in: rect, with: cornerRadius)
		default:
			return NSBezierPath(rect: rect)
		}
	}
}
