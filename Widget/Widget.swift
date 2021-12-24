//
//  Widget.swift
//  Widget
//
//  Created by Dmitriy Sazonov on 19.12.21.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), image: UIImage(named: "QR")!, configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), image: qrCode, configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entries: [SimpleEntry] = [
            SimpleEntry(date: Date(), image: qrCode, configuration: configuration)
        ]

        let timeline = Timeline(entries: entries, policy: .never)
        completion(timeline)
    }
    
    var qrCode: UIImage { UIImage(named: "QR")! }
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
            .cornerRadius(4)
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
        WidgetEntryView(entry: SimpleEntry(date: Date(), image: Provider().qrCode, configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
