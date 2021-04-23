//
//  ContentView.swift
//  LockdownWatch WatchKit Extension
//
//  Created by Marco Quinten Privat on 17.04.21.
//

import SwiftUI

enum Tab {
    case curfew
    case graphs
    case settings
}

struct ContentView: View {
    @State var activeTab: Tab = SettingsModel.shared.curfewEnabled ? .curfew : .graphs
    @ObservedObject var state: AppState = .shared
    @ObservedObject var settings: SettingsModel = .shared
    
    init() {
        state.requestPermissions()
        state.setupNotifications()
    }
    
    var body: some View {
        TabView(selection: $activeTab) {
            if settings.curfewEnabled {
                CurfewView()
                    .tabItem {
                        Image(systemName: "house")
                    }
                    .tag(Tab.curfew)
            }
            GraphView()
                .tabItem {
                    Image(systemName: "chart.pie")
                }
                .tag(Tab.graphs)
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                }
                .tag(Tab.settings)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
