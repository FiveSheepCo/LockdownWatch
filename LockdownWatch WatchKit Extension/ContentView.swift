//
//  ContentView.swift
//  LockdownWatch WatchKit Extension
//
//  Created by Marco Quinten Privat on 17.04.21.
//

import SwiftUI

enum Tab {
    case main
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
        HomeView()
//        TabView(selection: $activeTab) {
//            HomeView()
//                .tabItem {
//                    Image(systemName: "house")
//                }
//                .tag(Tab.main)
//            SettingsView()
//                .tabItem {
//                    Image(systemName: "gear")
//                }
//                .tag(Tab.settings)
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
