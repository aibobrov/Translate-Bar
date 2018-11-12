//
//  NSAttributedString.swift
//  ConvenientSwift
//
//  Created by abobrov on 14/09/2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Cocoa
import Foundation

extension Collection where Element: NSAttributedString {
    func joined(separator: String) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString()

        for (offset, element) in enumerated() {
            mutableAttributedString.append(element)
            if offset != count - 1 {
                mutableAttributedString.append(NSAttributedString(string: separator))
            }
        }
        return mutableAttributedString
    }
}

public extension Sequence {
    /// Creates dictionary from collection.
    ///
    /// - Parameter transform: Closure that transforms element into key-value pair.
    /// - Returns: Dictionary.
    public func dictionary<Key: Hashable, Value>(_ transform: (Element) -> (key: Key, value: Value)) -> [Key: Value] {
        return reduce(into: [:], { dictionary, element in
            let pair = transform(element)
            dictionary[pair.key] = pair.value
        })
    }
}

public extension NSAttributedString {
    /// Applies given attributes to the new instance of NSAttributedString in the specified range initialized with self object.
    ///
    /// - Parameters:
    ///   - attribures: Dictionary of attributes.
    ///   - range: Range to apply attributes to.
    /// - Returns: NSAttributedString with applied attributes.
    public func applying(attribures: [NSAttributedString.Key: Any], for range: NSRange) -> NSAttributedString {
        let copy = NSMutableAttributedString(attributedString: self)
        copy.addAttributes(attribures, range: range)
        return copy
    }

    /// Applies given attributes to the new instance of NSAttributedString initialized with self object
    ///
    /// - Parameter attribures: Dictionary of attributes.
    /// - Returns: NSAttributedString with applied attributes.
    public func applying(attribures: [NSAttributedString.Key: Any]) -> NSAttributedString {
        return applying(attribures: attribures, for: (string as NSString).range(of: string))
    }
}

/// Attribute options that you can apply to text in an attributed string.
public enum AttributedStringOption {
    /// Font.
    /// - value: NSFont object.
    case font(NSFont)

    /// Paragraph style.
    /// - value: NSParagraphStyle object.
    case paragraphStyle(NSParagraphStyle)

    /// Foreground color.
    /// - value: NSColor object.
    case foregroundColor(NSColor)

    /// Background color.
    /// - value: NSColor object.
    case backgroundColor(NSColor)

    /// Ligature.
    /// - value: NSNumber object containing an integer. The value 0 indicates no ligatures. The value 1 indicates the use of the default ligatures. The value 2 indicates the use of all ligatures.
    case ligature(NSNumber)

    /// Kern.
    /// - value: NSNumber object containing a floating-point value. This value specifies the number of points by which to adjust kern-pair characters. Kerning prevents unwanted space from occurring between specific characters and depends on the font. The value 0 means kerning is disabled.
    case kern(NSNumber)

    /// Strikethrough style.
    /// - value: NSNumber object containing an integer. This value indicates whether the text has a line through it and corresponds to one of the constants described in NSUnderlineStyle.
    case strikethroughStyle(NSNumber)

    /// Underline style.
    /// - value: NSNumber object containing an integer. This value indicates whether the text is underlined and corresponds to one of the constants described in NSUnderlineStyle.
    case underlineStyle(NSNumber)

    /// Stroke color.
    /// - value: NSColor object.
    case strokeColor(NSColor)

    /// Stroke width.
    /// - value: NSNumber object containing a floating-point value.
    case strokeWidth(NSNumber)

    /// Shadow.
    /// - value: NSShadow object.
    case shadow(NSShadow)

    /// Text effect.
    /// - value: NSString object.
    case textEffect(NSString)

    /// Attachment.
    /// - value: NSTextAttachment object.
    case attachment(NSTextAttachment)

    /// Link.
    /// - value: NSURL object.
    case link(String)

    /// Baseline offset.
    /// - value: NSNumber object containing a floating point value indicating the character’s offset from the baseline, in points.
    case baselineOffset(NSNumber)

    /// Underline color.
    /// - value: NSColor object.
    case underlineColor(NSColor)

    /// Strikethrough color.
    /// - value: NSColor object.
    case strikethroughColor(NSColor)

    /// Obliqueness.
    /// - value: NSNumber object containing a floating point value indicating skew to be applied to glyphs. The default value is 0, indicating no skew.
    case obliqueness(NSNumber)

    /// Expansion.
    /// - value: NSNumber object containing a floating point value indicating the log of the expansion factor to be applied to glyphs.
    case expansion(NSNumber)

    /// Writing direction.
    /// - value: NSArray object containing NSNumber objects representing the nested levels of writing direction overrides, in order from outermost to innermost.
    case writingDirection(NSArray)

    /// Vertical glyph form.
    /// - value: NSNumber object containing an integer. The value 0 indicates horizontal text. The value 1 indicates vertical text.
    case verticalGlyphForm(NSNumber)

    var key: NSAttributedString.Key {
        switch self {
        case .font:
            return .font
        case .paragraphStyle:
            return .paragraphStyle
        case .foregroundColor:
            return .foregroundColor
        case .backgroundColor:
            return .backgroundColor
        case .ligature:
            return .ligature
        case .kern:
            return .kern
        case .strikethroughStyle:
            return .strikethroughStyle
        case .underlineStyle:
            return .underlineStyle
        case .strokeColor:
            return .strokeColor
        case .strokeWidth:
            return .strokeWidth
        case .shadow:
            return .shadow
        case .textEffect:
            return .textEffect
        case .attachment:
            return .attachment
        case .link:
            return .link
        case .baselineOffset:
            return .baselineOffset
        case .underlineColor:
            return .underlineColor
        case .strikethroughColor:
            return .strikethroughColor
        case .obliqueness:
            return .obliqueness
        case .expansion:
            return .expansion
        case .writingDirection:
            return .writingDirection
        case .verticalGlyphForm:
            return .verticalGlyphForm
        }
    }

    var value: Any {
        switch self {
        case let .font(font):
            return font
        case let .paragraphStyle(style):
            return style
        case let .foregroundColor(color):
            return color
        case let .backgroundColor(color):
            return color
        case let .ligature(number):
            return number
        case let .kern(number):
            return number
        case let .strikethroughStyle(number):
            return number
        case let .underlineStyle(number):
            return number
        case let .strokeColor(color):
            return color
        case let .strokeWidth(number):
            return number
        case let .shadow(shadow):
            return shadow
        case let .textEffect(string):
            return string
        case let .attachment(attachment):
            return attachment
        case let .link(link):
            return link
        case let .baselineOffset(number):
            return number
        case let .underlineColor(color):
            return color
        case let .strikethroughColor(color):
            return color
        case let .obliqueness(number):
            return number
        case let .expansion(number):
            return number
        case let .writingDirection(array):
            return array
        case let .verticalGlyphForm(number):
            return number
        }
    }
}

public extension NSAttributedString {
    /// Applies given attribute options to the new instance of NSAttributedString in the specified range initialized with self object.
    ///
    /// - Parameters:
    ///   - options: Attribute options.
    ///   - range: Range to apply options to.
    /// - Returns: NSAttributedString with applied options.
    public func applying(options: [AttributedStringOption], for range: NSRange) -> NSAttributedString {
        return applying(attribures: options.dictionary { ($0.key, $0.value) }, for: range)
    }

    /// Applies given attribute options to the new instance of NSAttributedString in the specified range initialized with self object.
    ///
    /// - Parameters:
    ///   - options: Attribute options.
    ///   - range: Range to apply options to.
    /// - Returns: NSAttributedString with applied options.
    public func applying(_ options: AttributedStringOption..., for range: NSRange) -> NSAttributedString {
        return applying(options: options, for: range)
    }

    /// Applies given attribute options to the new instance of NSAttributedString initialized with self object.
    ///
    /// - Parameter options: Attribute options.
    /// - Returns: NSAttributedString with applied options.
    public func applying(options: [AttributedStringOption]) -> NSAttributedString {
        return applying(options: options, for: (string as NSString).range(of: string))
    }

    /// Applies given attribute options to the new instance of NSAttributedString in the specified range initialized with self object.
    ///
    /// - Parameter options: Attribute options.
    /// - Returns: NSAttributedString with applied options.
    public func applying(_ options: AttributedStringOption...) -> NSAttributedString {
        return applying(options: options)
    }
}

public extension NSAttributedString {
    /// Add a NSAttributedString to another NSAttributedString.
    ///
    /// - Parameters:
    ///   - lhs: NSAttributedString to add to.
    ///   - rhs: NSAttributedString to add.
    public static func += (lhs: inout NSAttributedString, rhs: NSAttributedString) {
        let string = NSMutableAttributedString(attributedString: lhs)
        string.append(rhs)
        lhs = string
    }

    /// Add a NSAttributedString to another NSAttributedString and return a new NSAttributedString instance.
    ///
    /// - Parameters:
    ///   - lhs: NSAttributedString to add.
    ///   - rhs: NSAttributedString to add.
    /// - Returns: New instance with added NSAttributedString.
    public static func + (lhs: NSAttributedString, rhs: NSAttributedString) -> NSAttributedString {
        let string = NSMutableAttributedString(attributedString: lhs)
        string.append(rhs)
        return NSAttributedString(attributedString: string)
    }

    /// Add a NSAttributedString to another NSAttributedString.
    ///
    /// - Parameters:
    ///   - lhs: NSAttributedString to add to.
    ///   - rhs: String to add to.
    public static func += (lhs: inout NSAttributedString, rhs: String) {
        lhs += NSAttributedString(string: rhs)
    }

    /// Add a NSAttributedString to another NSAttributedString and return a new NSAttributedString instance.
    ///
    /// - Parameters:
    ///   - lhs: NSAttributedString to add.
    ///   - rhs: String to add.
    /// - Returns: New instance with added NSAttributedString.
    public static func + (lhs: NSAttributedString, rhs: String) -> NSAttributedString {
        return lhs + NSAttributedString(string: rhs)
    }
}
