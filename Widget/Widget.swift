//
//  Widget.swift
//  Widget
//
//  Created by Dmitriy Sazonov on 19.12.21.
//

import WidgetKit
import SwiftUI
import Intents
import CoreImage.CIFilterBuiltins

struct Provider: IntentTimelineProvider {
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), image: UIImage(systemName: "qrcode")!, configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), image: generateQRCode(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, image: generateQRCode(), configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
    func generateQRCode() -> UIImage {
        guard let qrData = UserDefaults.standard.string(forKey: UserDefaultsConstants.QR) else {
            return UIImage(systemName: "qrcode")!
        }
        
        let data = Data(qrData.utf8)
        filter.setValue(data, forKey: "inputMessage")

        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }

        return UIImage(systemName: "qrcode") ?? UIImage()
    }
}

struct SimpleEntry: TimelineEntry {
    var date: Date
    let image: UIImage
    let configuration: ConfigurationIntent
}

struct WidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        Image(uiImage: entry.image)
            .resizable()
            .scaledToFit()
            .padding()
    }
}

@main
struct Widget: SwiftUI.Widget {
    let kind: String = "Widget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Home screen QR")
        .description("Place any QR code on your home screen.")
    }
}

struct Widget_Previews: PreviewProvider {
    static var previews: some View {
        WidgetEntryView(entry: SimpleEntry(date: Date(), image: Provider().generateQRCode(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
