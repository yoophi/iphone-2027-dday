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

// The installed iOS 26 simulator cannot host the iOS 27 portrait family.
// Preview its shared SwiftUI layout at the fourth-size widget dimensions.
#Preview("4단계 · 초대형 레이아웃") {
    CountdownView(model: CountdownModel(date: previewDate), large: true, expanded: true)
        .frame(width: 330, height: 530)
        .padding(16)
        .background(Color.white)
}

#Preview("전체 화면 레이아웃") {
    CountdownView(model: CountdownModel(date: previewDate), large: true, expanded: true)
        .padding(.horizontal, 28)
        .padding(.top, 44)
        .padding(.bottom, 28)
        .background(Color.white)
}
