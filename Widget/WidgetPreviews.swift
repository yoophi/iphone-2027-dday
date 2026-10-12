import SwiftUI
import WidgetKit

private let previewDate: Date = {
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = .autoupdatingCurrent
    return calendar.date(from: DateComponents(year: 2026, month: 10, day: 12, hour: 12))!
}()

#Preview("2단계 · 중형", as: .systemMedium) {
    CountdownWidget()
} timeline: {
    CountdownEntry(date: previewDate)
}

#Preview("3단계 · 대형", as: .systemLarge) {
    CountdownWidget()
} timeline: {
    CountdownEntry(date: previewDate)
}
