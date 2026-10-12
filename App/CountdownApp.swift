import SwiftUI
import WidgetKit

@main struct CountdownApp: App {
    var body: some Scene {
        WindowGroup { ContentView().preferredColorScheme(.light) }
    }
}

struct ContentView: View {
    @Environment(\.scenePhase) private var scenePhase
    var body: some View {
        TimelineView(.periodic(from: .now, by: 60)) { context in
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    Text("2027").font(.system(size: 38, weight: .bold, design: .rounded))
                    Text("2027년 1월 1일까지").foregroundStyle(Color(white: 0.45))
                    CountdownView(model: CountdownModel(date: context.date))
                        .frame(height: 150).padding(20)
                        .background(RoundedRectangle(cornerRadius: 24).stroke(Color(white: 0.88)))
                    CountdownView(model: CountdownModel(date: context.date), large: true)
                        .frame(height: 320).padding(20)
                        .background(RoundedRectangle(cornerRadius: 24).stroke(Color(white: 0.88)))
                    VStack(alignment: .leading, spacing: 12) {
                        Text("홈 화면에 추가").font(.headline)
                        Text("홈 화면의 빈 공간을 길게 누른 뒤 편집 → 위젯 추가 → ‘2027’을 선택하세요. 가로형 또는 큰 위젯을 추가할 수 있습니다.")
                        Text("지난 날짜는 연한 회색, 오늘은 검정 원으로 표시됩니다. 날짜는 매일 자정 기준으로 바뀝니다.")
                            .foregroundStyle(Color(white: 0.45))
                    }.font(.subheadline)
                }.padding(24)
            }.background(Color.white).foregroundStyle(Color.black)
        }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active { WidgetCenter.shared.reloadAllTimelines() }
        }
    }
}
