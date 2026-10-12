import Foundation

var checks = 0
func check(_ condition: @autoclosure () -> Bool, _ message: String) {
    precondition(condition(), message)
    checks += 1
}
func model(_ year: Int, _ month: Int, _ day: Int, zone: String = "Asia/Seoul", hour: Int = 12) -> CountdownModel {
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = TimeZone(identifier: zone)!
    let date = calendar.date(from: DateComponents(year: year, month: month, day: day, hour: hour))!
    return CountdownModel(date: date, calendar: calendar)
}
check(model(2026, 10, 12).daysRemaining == 81, "October countdown")
check(model(2026, 12, 31).daysRemaining == 1, "Year boundary")
check(model(2027, 1, 1).daysRemaining == 0, "Target day")
check(model(2027, 2, 1).daysRemaining == 0, "Clamp after target")
check(model(2026, 10, 12, hour: 23).daysRemaining == 81, "Calendar days, not hours")
check(model(2026, 10, 12).cells.prefix(4).allSatisfy { $0 == nil }, "Thursday offset")
check(model(2026, 10, 12).cells.compactMap { $0 } == Array(1...31), "October dates")
check(model(2026, 8, 1).cells.count == 42, "Six-week month")
check(model(2028, 2, 1).cells.compactMap { $0 }.count == 29, "Leap February")
check(model(2026, 11, 1, zone: "America/New_York").daysRemaining == 61, "DST countdown")
let dst = model(2026, 11, 1, zone: "America/New_York")
check(dst.nextMidnight.timeIntervalSince(dst.today) == 25 * 3600, "DST midnight")
let last = model(2026, 10, 31)
check(CountdownModel(date: last.nextMidnight, calendar: last.calendar).monthTitle == "2026년 11월", "Month rollover")
for month in 1...12 {
    let value = model(2026, month, 15)
    check(value.cells.count % 7 == 0, "Full calendar rows")
    check(value.cells.compactMap { $0 }.first == 1, "First day")
}
print("Passed \(checks) calendar and countdown checks")
