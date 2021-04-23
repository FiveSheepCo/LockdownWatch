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
        curfewWarn = TimeComponent(settings.curfewWarn)
        curfewStart = TimeComponent(settings.curfewStart)
        curfewEnd = TimeComponent(settings.curfewEnd)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                Toggle("Enabled", isOn: $settings.curfewEnabled).toggleStyle(SwitchToggleStyle())
                if settings.curfewEnabled {
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
        }
        .navigationTitle("Curfew")
        .onAppear {
            curfewWarn.update(settings.curfewWarn)
            curfewStart.update(settings.curfewStart)
            curfewEnd.update(settings.curfewEnd)
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
