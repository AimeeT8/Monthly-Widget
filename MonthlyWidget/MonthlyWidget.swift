//
//  MonthlyWidget.swift
//  MonthlyWidget
//
//  Created by Temple on 2024-07-03.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> DayEntry {
        DayEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (DayEntry) -> ()) {
        let entry = DayEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [DayEntry] = []

        // Generate a timeline consisting of seven entries a day apart, starting from the current date.
        let currentDate = Date()
        for dayOffset in 0 ..< 7 {
            let entryDate = Calendar.current.date(byAdding: .day, value: dayOffset, to: currentDate)!
            let startOfDate = Calendar.current.startOfDay(for: entryDate)
            let entry = DayEntry(date: startOfDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct DayEntry: TimelineEntry {
    let date: Date
    
}

struct MonthlyWidgetEntryView : View {
    @Environment(\.showsWidgetContainerBackground) var showsBackground
    @Environment(\.widgetRenderingMode) var renderingMode //Use rederingMode if the night mode doesn't look right while testing.
    var entry: DayEntry
    var config: MonthConfig
    
    init(entry: DayEntry) {
        self.entry = entry
        self.config = MonthConfig.determineConfig(from: entry.date)
    }
    

    var body: some View {
        
            
        VStack {
            HStack(spacing: 4) {
                Text(config.emojiText)
                    .font(.title)
                Text(entry.date.weekdayDisplayFormat)
                    .font(.title3)
                    .fontWeight(.bold)
                    .minimumScaleFactor(0.6)
                    .foregroundStyle(showsBackground ? config.weekdayTextColor : .white)
                 Spacer()
                
            }
            .id(entry.date)
            .transition(.push(from: .trailing))
            .animation(.bouncy, value: entry.date)
            
            Text(entry.date.dayDisplayFormat)
                .font(.system(size: 80, weight: .heavy))
                .foregroundStyle(showsBackground ? config.dayTextColor : .white)
                .contentTransition(.numericText())
        }
        .containerBackground(for: .widget) {
            ContainerRelativeShape()
                .fill(config.backgroundColor.gradient)
        }
        
        
    }
    
}


struct MonthlyWidget: Widget {
    let kind: String = "MonthlyWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                MonthlyWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                MonthlyWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
       
        .configurationDisplayName("Monthly Style Widget")
        .description("The theme of the widget changes based on month.")
        .supportedFamilies([.systemSmall])
    }
}

#Preview(as: .systemSmall) {
    MonthlyWidget()
} timeline: {
    MockData.dayOne
    MockData.dayTwo
    MockData.dayThree
    MockData.dayFour
    MockData.dayFive
    MockData.daySix
    MockData.daySeven
    MockData.dayEight
    MockData.dayNine
    MockData.dayTen
    MockData.dayEleven
    MockData.dayTwelve
    
    
    
}

struct MockData {
    static let dayOne = DayEntry(date: dateToDisplay(month: 11, day: 4))
    static let dayTwo = DayEntry(date: dateToDisplay(month: 12, day: 25))
    static let dayThree = DayEntry(date: dateToDisplay(month: 10, day: 22))
    static let dayFour = DayEntry(date: dateToDisplay(month: 9, day: 11))
    static let dayFive = DayEntry(date: dateToDisplay(month: 8, day: 9))
    static let daySix = DayEntry(date: dateToDisplay(month: 7, day: 22))
    static let daySeven = DayEntry(date: dateToDisplay(month: 6, day: 2))
    static let dayEight = DayEntry(date: dateToDisplay(month: 5, day: 13))
    static let dayNine = DayEntry(date: dateToDisplay(month: 4, day: 26))
    static let dayTen = DayEntry(date: dateToDisplay(month: 3, day: 5))
    static let dayEleven = DayEntry(date: dateToDisplay(month: 2, day: 17))
    static let dayTwelve = DayEntry(date: dateToDisplay(month: 1, day: 1))

}


func dateToDisplay(month: Int, day: Int) -> Date {
        
        let components = DateComponents(calendar: Calendar.current, year: 2023, month: month, day: day)
        
        return Calendar.current.date(from: components)!
        
    
    
}
extension Date {
    var weekdayDisplayFormat: String {
        self.formatted(.dateTime.weekday(.wide))
    }
    
    var dayDisplayFormat: String {
        self.formatted(.dateTime.day())
    }
}
