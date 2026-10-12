import SwiftUI
import WidgetKit

@main struct CountdownApp: App {
    init() {
        #if DEBUG
        print("2027 supported widget families: " + WidgetSizes.supported.map { "\($0.rawValue):\($0.description)" }.joined(separator: ", "))
        fflush(stdout)
        #endif
    }
    var body: some Scene {
        WindowGroup { ContentView().preferredColorScheme(.light) }
    }
}

struct ContentView: View {
    @Environment(\.scenePhase) private var scenePhase
    @State private var showFullscreen = true
    var body: some View {
        TimelineView(.periodic(from: .now, by: 60)) { context in
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    Text("2027").font(.system(size: 38, weight: .bold, design: .default))
                    Text("2027년 1월 1일까지").foregroundStyle(Color(white: 0.45))
                    CountdownView(model: CountdownModel(date: context.date))
                        .frame(height: 150).padding(20)
                        .background(RoundedRectangle(cornerRadius: 24).stroke(Color(white: 0.88)))
                    CountdownView(model: CountdownModel(date: context.date), large: true)
                        .frame(height: 320).padding(20)
                        .background(RoundedRectangle(cornerRadius: 24).stroke(Color(white: 0.88)))
                    Button {
                        showFullscreen = true
                    } label: {
                        Label("전체 화면 보기", systemImage: "arrow.up.left.and.arrow.down.right")
                            .font(.headline).foregroundStyle(Color.black)
                    }
                    VStack(alignment: .leading, spacing: 12) {
                        Text("홈 화면에 추가").font(.headline)
                        Text("홈 화면의 빈 공간을 길게 누른 뒤 편집 → 위젯 추가 → ‘2027’을 선택하세요. 가로형 또는 큰 위젯을 추가할 수 있습니다.")
                        Text("지난 날짜는 연한 회색, 오늘은 검정 원으로 표시됩니다. 날짜는 매일 자정 기준으로 바뀝니다.")
                            .foregroundStyle(Color(white: 0.45))
                    }.font(.subheadline)
                }.padding(24)
            }.background(Color.white).foregroundStyle(Color.black)
        }
        .fullScreenCover(isPresented: $showFullscreen) {
            FullscreenCountdownView()
        }
        .onOpenURL { url in
            if url.scheme == "countdown2027" { showFullscreen = true }
        }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active { WidgetCenter.shared.reloadAllTimelines() }
        }
    }
}


struct FullscreenCountdownView: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        TimelineView(.periodic(from: .now, by: 60)) { context in
            CountdownView(model: CountdownModel(date: context.date), large: true, expanded: true)
                .padding(.horizontal, 28)
                .padding(.top, 44)
                .padding(.bottom, 28)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white.ignoresSafeArea())
                .overlay(alignment: .topTrailing) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark").font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(Color(white: 0.45)).frame(width: 44, height: 44)
                    }.accessibilityLabel("전체 화면 닫기").padding(.trailing, 12)
                }
        }
        .preferredColorScheme(.light)
        .statusBarHidden(true)
    }
}
