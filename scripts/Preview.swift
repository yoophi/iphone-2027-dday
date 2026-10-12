import SwiftUI
import AppKit

@main struct Preview {
    @MainActor static func main() {
        let output = CommandLine.arguments.dropFirst().first ?? "/tmp/iphone-2027-preview.png"
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
        let date = calendar.date(from: DateComponents(year: 2026, month: 10, day: 12, hour: 12))!
        let model = CountdownModel(date: date, calendar: calendar)
        let view = VStack(spacing: 24) {
            CountdownView(model: model).frame(width: 330, height: 140).padding(16)
                .background(Color.white).clipShape(RoundedRectangle(cornerRadius: 24))
            CountdownView(model: model, large: true).frame(width: 330, height: 310).padding(16)
                .background(Color.white).clipShape(RoundedRectangle(cornerRadius: 24))
        }.padding(24).background(Color(white: 0.92))
        let renderer = ImageRenderer(content: view)
        renderer.scale = 3
        let bitmap = NSBitmapImageRep(cgImage: renderer.cgImage!)
        try! bitmap.representation(using: .png, properties: [:])!.write(to: URL(fileURLWithPath: output))
    }
}
