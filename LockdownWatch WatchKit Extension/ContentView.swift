//
//  ContentView.swift
//  LockdownWatch WatchKit Extension
//
//  Created by Marco Quinten Privat on 17.04.21.
//

import SwiftUI

enum Tab {
    case main
    case graphs
    case settings
}

struct ContentView: View {
    @State var activeTab: Tab = .main
    @ObservedObject var state: AppState = .shared
    
    init() {
        state.requestPermissions()
        state.setupNotifications()
    }
    
    var body: some View {
        TabView(selection: $activeTab) {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                }
                .tag(Tab.main)
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
