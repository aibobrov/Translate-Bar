//
//  FixedQueue.swift
//  Translate Bar
//
//  Created by abobrov on 27/06/2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Foundation

public struct FixedQueue<T: Equatable> {
    public typealias QueueType = [T]
    public typealias Index = QueueType.Index
    public typealias Element = QueueType.Element

    fileprivate var array: [T] = []
	fileprivate var indexToPush: Int

    public init(_ values: T...) {
		indexToPush = values.count - 1
        for value in values {
            array.append(value)
        }
    }

    public var isEmpty: Bool {
        return count == 0
    }

    public var count: Int {
        return array.count
    }

    public var front: T? {
        return array[indexToPush]
    }

	@discardableResult
    public mutating func push(_ element: T) -> (Int, T?) {
        guard !isEmpty else { return (-1, nil) }
		defer {
			array[indexToPush] = element

			indexToPush -= 1
			if indexToPush < 0 {
				indexToPush = array.count - 1
			}
		}
		return (indexToPush, array[indexToPush])
    }
}

extension FixedQueue: Collection {
    public func index(after index: Index) -> Index {
        return array.index(after: index)
    }

    public subscript(position: Index) -> Element {
		get {
			return array[position]
		}
		set {
			array[position] = newValue
		}
    }

    public var startIndex: Index {
        return array.startIndex
    }

    public var endIndex: Index {
        return array.endIndex
    }
}
