import AppKit

let pixels = CommandLine.arguments.count > 2 ? Int(CommandLine.arguments[2])! : 1024
let bitmap = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: pixels, pixelsHigh: pixels, bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0)!
NSGraphicsContext.saveGraphicsState()
NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: bitmap)
NSGraphicsContext.current!.cgContext.scaleBy(x: CGFloat(pixels) / 1024, y: CGFloat(pixels) / 1024)
NSColor.white.setFill()
NSBezierPath(rect: NSRect(x: 0, y: 0, width: 1024, height: 1024)).fill()
let style = NSMutableParagraphStyle()
style.alignment = .center
("27" as NSString).draw(in: NSRect(x: 70, y: 265, width: 884, height: 510), withAttributes: [
    .font: NSFont.systemFont(ofSize: 450, weight: .bold),
    .foregroundColor: NSColor.black,
    .paragraphStyle: style
])
NSColor(white: 0.75, alpha: 1).setFill()
for column in 0..<7 {
    NSBezierPath(roundedRect: NSRect(x: 190 + column * 96, y: 195, width: 40, height: 40), xRadius: 20, yRadius: 20).fill()
}
NSGraphicsContext.restoreGraphicsState()
try bitmap.representation(using: .png, properties: [:])!.write(to: URL(fileURLWithPath: CommandLine.arguments[1]))
