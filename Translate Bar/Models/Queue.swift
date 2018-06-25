//
//  Queue.swift
//  Translate Bar
//
//  Created by abobrov on 25/06/2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Foundation

public struct Queue<T> {
    public typealias QueueType = [T?]
    public typealias Index = QueueType.Index
    public typealias Element = QueueType.Element

    fileprivate var array = [T?]()
    fileprivate var head = 0

    public init(_ values: T...) {
        for value in values {
            enqueue(value)
        }
    }

    public var isEmpty: Bool {
        return count == 0
    }

    public var count: Int {
        return array.count - head
    }

    public mutating func enqueue(_ element: T) {
        array.append(element)
    }

    public mutating func dequeue() -> T? {
        guard head < array.count, let element = array[head] else { return nil }

        array[head] = nil
        head += 1

        let percentage = Double(head)/Double(array.count)
        if array.count > 50 && percentage > 0.25 {
            array.removeFirst(head)
            head = 0
        }

        return element
    }

    public var front: T? {
        return isEmpty ? nil : array[head]
    }
}
extension Queue: Collection {
    public func index(after i: Index) -> Index {
        return array.index(after: i)
    }

    public subscript(position: Index) -> Element {
        return array[position]
    }

    public var startIndex: Index {
        return array.startIndex
    }

    public var endIndex: Index {
        return array.endIndex
    }
}
