import SwiftUI

struct CountdownView: View {
    let model: CountdownModel
    var large = false

    var body: some View {
        GeometryReader { geometry in
            if large {
                VStack(spacing: 12) {
                    number(size: min(geometry.size.height * 0.34, 112))
                        .frame(maxWidth: .infinity, maxHeight: geometry.size.height * 0.38)
                    monthCalendar
                }
            } else {
                HStack(spacing: 18) {
                    number(size: min(geometry.size.width * 0.25, 96))
                        .frame(width: geometry.size.width * 0.39)
                    monthCalendar
                }
            }
        }
        .foregroundStyle(Color.black)
        .environment(\.colorScheme, .light)
        .accessibilityElement(children: .contain)
    }

    private func number(size: CGFloat) -> some View {
        (Text("D-").font(.system(size: size * 0.38, weight: .bold, design: .rounded))
        + Text(model.daysRemaining.formatted(.number.grouping(.never)))
            .font(.system(size: size, weight: .bold, design: .rounded)))
            .monospacedDigit()
            .lineLimit(1)
            .minimumScaleFactor(0.45)
            .accessibilityLabel("2027년 1월 1일까지 \(model.daysRemaining)일 남음")
    }

    private var monthCalendar: some View {
        VStack(spacing: large ? 12 : 6) {
            Text(model.monthTitle)
                .font(.system(size: large ? 16 : 12, weight: .semibold))
                .frame(maxWidth: .infinity, alignment: .leading)
            GeometryReader { geometry in
                let rows = model.cells.count / 7 + 1
                let cellHeight = geometry.size.height / CGFloat(rows)
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        ForEach(Array(["일", "월", "화", "수", "목", "금", "토"].enumerated()), id: \.offset) { _, label in
                            Text(label)
                                .font(.system(size: large ? 12 : 9, weight: .medium))
                                .foregroundStyle(Color(white: 0.45))
                                .frame(maxWidth: .infinity)
                        }
                    }.frame(height: cellHeight)
                    ForEach(0..<(model.cells.count / 7), id: \.self) { row in
                        HStack(spacing: 0) {
                            ForEach(0..<7, id: \.self) { column in
                                dayCell(model.cells[row * 7 + column], height: cellHeight)
                                    .frame(maxWidth: .infinity)
                            }
                        }.frame(height: cellHeight)
                    }
                }
            }
        }
    }

    @ViewBuilder private func dayCell(_ day: Int?, height: CGFloat) -> some View {
        if let day {
            let isToday = day == model.todayNumber
            let isPast = day < model.todayNumber
            Text("\(day)")
                .font(.system(size: large ? 15 : 10, weight: isToday ? .bold : .medium))
                .monospacedDigit()
                .foregroundStyle(isToday ? Color.white : (isPast ? Color(white: 0.75) : Color.black))
                .frame(width: min(height - 1, large ? 30 : 20), height: min(height - 1, large ? 30 : 20))
                .background { if isToday { Circle().fill(Color.black) } }
                .accessibilityLabel("\(day)일\(isToday ? ", 오늘" : (isPast ? ", 지난 날짜" : ""))")
        } else {
            Color.clear.accessibilityHidden(true)
        }
    }
}
