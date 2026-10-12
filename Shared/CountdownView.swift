import SwiftUI

struct CountdownView: View {
    let model: CountdownModel
    var large = false
    var expanded = false

    var body: some View {
        GeometryReader { geometry in
            if large {
                VStack(spacing: 12) {
                    number(size: min(geometry.size.height * 0.34, expanded ? geometry.size.width * 0.46 : 112))
                        .frame(maxWidth: .infinity, maxHeight: geometry.size.height * (expanded ? 0.5 : 0.46), alignment: .leading)
                    monthCalendar
                }
            } else {
                HStack(spacing: 18) {
                    number(size: min(geometry.size.width * 0.25, 96))
                        .frame(width: geometry.size.width * 0.39, alignment: .leading)
                    monthCalendar
                }
            }
        }
        .foregroundStyle(Color.black)
        .environment(\.colorScheme, .light)
        .accessibilityElement(children: .contain)
    }

    private func number(size: CGFloat) -> some View {
        let scaledSize = size * 1.25
        return VStack(alignment: .leading, spacing: 2) {
            Text("새해까지")
                .font(.system(size: max(12, min(scaledSize * 0.14, 24)), weight: .regular, design: .default))
                .foregroundStyle(Color(white: 0.45))
                .lineLimit(1)
            Text(model.daysRemaining.formatted(.number.grouping(.never)))
                .font(.system(size: scaledSize, weight: .heavy, design: .default).width(.condensed))
                .monospacedDigit()
                .lineLimit(1)
                .minimumScaleFactor(0.45)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("2027년 1월 1일까지 \(model.daysRemaining)일 남음")
    }

    private var monthCalendar: some View {
        VStack(spacing: large ? 12 : 6) {
            Text(model.monthTitle)
                .font(.system(size: expanded ? 24 : (large ? 16 : 12), weight: .semibold))
                .frame(maxWidth: .infinity, alignment: .leading)
            GeometryReader { geometry in
                let rows = model.cells.count / 7 + 1
                let cellHeight = geometry.size.height / CGFloat(rows)
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        ForEach(Array(["일", "월", "화", "수", "목", "금", "토"].enumerated()), id: \.offset) { _, label in
                            Text(label)
                                .font(.system(size: expanded ? 18 : (large ? 12 : 9), weight: .medium))
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
            let preferredFont: CGFloat = expanded ? 24 : (large ? 15 : 10)
            let diameter = min(height - 1, expanded ? 44 : (large ? 30 : 20))
            let fontSize = isToday ? min(preferredFont, diameter * 0.58) : preferredFont
            Text("\(day)")
                .font(.system(size: fontSize, weight: isToday ? .bold : .medium))
                .monospacedDigit()
                .foregroundStyle(isToday ? Color.white : (isPast ? Color(white: 0.75) : Color.black))
                .frame(width: diameter, height: diameter)
                .background { if isToday { Circle().fill(Color.black) } }
                .accessibilityLabel("\(day)일\(isToday ? ", 오늘" : (isPast ? ", 지난 날짜" : ""))")
        } else {
            Color.clear.accessibilityHidden(true)
        }
    }
}


private var countdownPreviewDate: Date {
    Calendar(identifier: .gregorian).date(from: DateComponents(year: 2026, month: 10, day: 12, hour: 12))!
}

#Preview("4단계 · 초대형 레이아웃", traits: .sizeThatFitsLayout) {
    CountdownView(model: CountdownModel(date: countdownPreviewDate), large: true, expanded: true)
        .frame(width: 330, height: 530)
        .padding(16)
        .background(Color.white)
}

#Preview("전체 화면 레이아웃") {
    CountdownView(model: CountdownModel(date: countdownPreviewDate), large: true, expanded: true)
        .padding(.horizontal, 28)
        .padding(.top, 44)
        .padding(.bottom, 28)
        .background(Color.white)
}
