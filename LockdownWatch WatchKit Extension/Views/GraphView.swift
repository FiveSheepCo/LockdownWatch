//
//  GraphView.swift
//  LockdownWatch WatchKit Extension
//
//  Created by Marco Quinten Privat on 18.04.21.
//

import SwiftUI

struct GraphEntry<Content: View>: View {
    let name: String
    let content: () -> Content
    
    init(name: String, @ViewBuilder content: @escaping () -> Content) {
        self.name = name
        self.content = content
    }
    
    var body: some View {
        VStack {
            Text(name).bold().opacity(0.75).font(.system(size: 10))
            content().padding(.top, 2)
        }
        .font(.system(size: 12))
        .padding(4)
        .frame(maxWidth: .infinity)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(4)
    }
}

struct GraphView: View {
    @ObservedObject var settings: SettingsModel = .shared
    @ObservedObject var rkiFetcher = RKIFetcher.shared
    @ObservedObject var jhuFetcher = JHUFetcher.shared
    
    init() {
        rkiFetcher.fetch()
        jhuFetcher.fetch()
    }
    
    var columns: [GridItem] {
        let device = WKInterfaceDevice.current()
        let item = GridItem(
            .fixed(device.screenBounds.width / 2 - 4),
            spacing: 2,
            alignment: .center
        )
        return Array(repeating: item, count: 2)
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 2) {
            
            // John Hopkins University Data
            if let data = jhuFetcher.data {
                Text("\(data.country) (\(data.state))")
                LazyVGrid(columns: columns, spacing: 2) {
                    GraphEntry(name: "🤧 Confirmed") {
                        Text(String(data.confirmed))
                    }
                    GraphEntry(name: "☠️ Deaths") {
                        Text(String(data.deaths))
                    }
                    GraphEntry(name: "🟢 Recovered") {
                        Text(String(data.recovered))
                    }
                    GraphEntry(name: "⏳ Active") {
                        Text(String(data.active))
                    }
                }
            }
            
            // Robert Koch Institute Data
            if let data = rkiFetcher.vaxData, settings.country == "Germany" {
                LazyVGrid(columns: columns, spacing: 2) {
                    GraphEntry(name: "💉 1st Shot") {
                        Text("\(data.data.quote * 100, specifier: "%.2f")%")
                    }
                    GraphEntry(name: "💉 2nd Shot") {
                        Text("\(data.data.secondVaccination.quote * 100, specifier: "%.2f")%")
                    }
                }
            }
        }
    }
}

struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        GraphView()
    }
}
