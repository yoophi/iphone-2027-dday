import Foundation

struct CountdownModel {
    let date: Date
    var calendar: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.timeZone = .autoupdatingCurrent
        calendar.firstWeekday = 1
        return calendar
    }()

    var today: Date { calendar.startOfDay(for: date) }
    var target: Date { calendar.date(from: DateComponents(year: 2027, month: 1, day: 1))! }
    var daysRemaining: Int { max(0, calendar.dateComponents([.day], from: today, to: target).day ?? 0) }
    var monthStart: Date { calendar.date(from: calendar.dateComponents([.year, .month], from: date))! }
    var monthTitle: String { "\(calendar.component(.year, from: date))년 \(calendar.component(.month, from: date))월" }
    var todayNumber: Int { calendar.component(.day, from: date) }
    var cells: [Int?] {
        let leading = (calendar.component(.weekday, from: monthStart) - calendar.firstWeekday + 7) % 7
        let count = calendar.range(of: .day, in: .month, for: date)!.count
        let occupied = leading + count
        let trailing = (7 - occupied % 7) % 7
        return Array(repeating: nil, count: leading) + (1...count).map { Optional($0) } + Array(repeating: nil, count: trailing)
    }
    var nextMidnight: Date { calendar.date(byAdding: .day, value: 1, to: today)! }
}
