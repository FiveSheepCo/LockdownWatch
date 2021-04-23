//
//  CurfewSettingsView.swift
//  LockdownWatch WatchKit Extension
//
//  Created by Marco Quinten Privat on 18.04.21.
//

import SwiftUI

struct CurfewSettingsView: View {
    @ObservedObject var settings: SettingsModel = .shared
    
    @ObservedObject private var curfewWarn: TimeComponent
    @ObservedObject private var curfewStart: TimeComponent
    @ObservedObject private var curfewEnd: TimeComponent
    
    init() {
        let settings = SettingsModel.shared
        curfewWarn = TimeComponent(settings.curfewWarn ?? 20.5)
        curfewStart = TimeComponent(settings.curfewStart ?? 21)
        curfewEnd = TimeComponent(settings.curfewEnd ?? 5)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                VStack(spacing: 0) {
                    Text("Warn at")
                    TimePicker(timeComponent: curfewWarn)
                }
                VStack(spacing: 0) {
                    Text("Starts at")
                    TimePicker(timeComponent: curfewStart)
                }
                VStack(spacing: 0) {
                    Text("Ends at")
                    TimePicker(timeComponent: curfewEnd)
                }
            }
        }
        .navigationTitle("Curfew")
        .onAppear {
            curfewWarn.update(settings.curfewWarn ?? 20.5)
            curfewStart.update(settings.curfewStart ?? 21)
            curfewEnd.update(settings.curfewEnd ?? 5)
        }
        .onDisappear {
            settings.curfewWarn = curfewWarn.time
            settings.curfewStart = curfewStart.time
            settings.curfewEnd = curfewEnd.time
            AppState.shared.setupNotifications()
        }
    }
}

struct CurfewSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        CurfewSettingsView()
    }
}
