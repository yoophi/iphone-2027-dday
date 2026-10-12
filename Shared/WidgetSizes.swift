import WidgetKit

/// iOS 27 adds the fourth iPhone gallery size, the extra-large portrait family.
/// Xcode 26 exposes its named case only for visionOS; resolve it through the
/// public RawRepresentable initializer on iOS 27 until the project uses SDK 27.
enum WidgetSizes {
    static var extraLargePortrait: WidgetFamily? {
        guard #available(iOS 27.0, *) else { return nil }
        return WidgetFamily(rawValue: 4)
    }

    static var supported: [WidgetFamily] {
        var families: [WidgetFamily] = [.systemMedium, .systemLarge]
        if let portrait = extraLargePortrait { families.append(portrait) }
        return families
    }

    static func isExtraLargePortrait(_ family: WidgetFamily) -> Bool {
        extraLargePortrait == family
    }
}
