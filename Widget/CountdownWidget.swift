import SwiftUI
import WidgetKit

struct CountdownEntry: TimelineEntry { let date: Date }

struct CountdownProvider: TimelineProvider {
    func placeholder(in context: Context) -> CountdownEntry { CountdownEntry(date: .now) }
    func getSnapshot(in context: Context, completion: @escaping (CountdownEntry) -> Void) {
        completion(CountdownEntry(date: .now))
    }
    func getTimeline(in context: Context, completion: @escaping (Timeline<CountdownEntry>) -> Void) {
        let now = Date.now
        let calendar = CountdownModel(date: now).calendar
        let midnight = calendar.startOfDay(for: now)
        // Preload a week of midnight updates, including month and year boundaries.
        let entries = [CountdownEntry(date: now)] + (1...7).compactMap { offset in
            calendar.date(byAdding: .day, value: offset, to: midnight).map { CountdownEntry(date: $0) }
        }
        completion(Timeline(entries: entries, policy: .atEnd))
    }
}

struct CountdownWidgetView: View {
    let entry: CountdownEntry
    @Environment(\.widgetFamily) private var family
    var body: some View {
        CountdownView(model: CountdownModel(date: entry.date), large: family == .systemLarge)
            .containerBackground(Color.white, for: .widget)
    }
}

@main struct CountdownWidget: Widget {
    let kind = "NewYear2027Countdown"
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CountdownProvider()) { entry in
            CountdownWidgetView(entry: entry)
        }
        .configurationDisplayName("2027")
        .description("2027년 1월 1일까지 남은 날짜와 이번 달 달력")
        .supportedFamilies([.systemMedium, .systemLarge])
        .containerBackgroundRemovable(false)
    }
}
