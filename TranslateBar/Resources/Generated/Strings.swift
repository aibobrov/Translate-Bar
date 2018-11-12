// swiftlint:disable all
// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {
    /// german
    internal static let de = L10n.tr("Localizable", "de")
    /// detect language
    internal static let detect = L10n.tr("Localizable", "detect")
    /// detected language
    internal static let detected = L10n.tr("Localizable", "detected")
    /// english
    internal static let en = L10n.tr("Localizable", "en")
    /// Quit Translate Bar
    internal static let quit = L10n.tr("Localizable", "quit")
    /// russian
    internal static let ru = L10n.tr("Localizable", "ru")
    /// Settings
    internal static let settings = L10n.tr("Localizable", "settings")
    /// Did you mean
    internal static let suggest = L10n.tr("Localizable", "suggest")
}

// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension L10n {
    private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
        let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
        return String(format: format, locale: Locale.current, arguments: args)
    }
}

private final class BundleToken {}
