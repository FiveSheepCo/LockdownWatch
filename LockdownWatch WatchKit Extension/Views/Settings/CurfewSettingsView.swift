//
//  CurfewSettingsView.swift
//  LockdownWatch WatchKit Extension
//
//  Created by Marco Quinten Privat on 18.04.21.
//

import SwiftUI

struct TimePicker: View {
    @Binding var value: TimeInterval
    @State private var isFocused: Bool = false

    static let formatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        return formatter
    }()

    var body: some View {
        Text(Self.formatter.string(from: value)!)
            .font(.title2)
            .focusable(true, onFocusChange: { focused in
                isFocused = focused
            })
            .digitalCrownRotation(
                $value,
                from: 0,
                through: 3600 * 24 - 1,
                by: 60,
                sensitivity: .high,
                isContinuous: true,
                isHapticFeedbackEnabled: true
            )
            .padding(.horizontal, 4)
            .border(Color.accentColor, width: isFocused ? 2 : 0)
            .cornerRadius(3)
    }
}

struct CurfewSettingsView: View {
    @ObservedObject var settings: SettingsModel = .shared
    
    @State private var curfewWarn: TimeInterval
    @State private var curfewStart: TimeInterval
    @State private var curfewEnd: TimeInterval
    
    init() {
        let settings = SettingsModel.shared
        _curfewWarn = State(initialValue: (settings.curfewWarn ?? 20.5) * 3600)
        _curfewStart = State(initialValue: (settings.curfewStart ?? 21) * 3600)
        _curfewEnd = State(initialValue: (settings.curfewEnd ?? 5) * 3600)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                VStack(spacing: 0) {
                    Text("Curfew Warning")
                    TimePicker(value: $curfewWarn)
                }
                VStack(spacing: 0) {
                    Text("Curfew Start")
                    TimePicker(value: $curfewStart)
                }
                VStack(spacing: 0) {
                    Text("Curfew End")
                    TimePicker(value: $curfewEnd)
                }
            }
        }
        .navigationTitle("Curfew")
        .onAppear {
            curfewWarn = (settings.curfewWarn ?? 20.5) * 3600
            curfewStart = (settings.curfewStart ?? 21) * 3600
            curfewEnd = (settings.curfewEnd ?? 5) * 3600
        }
        .onDisappear {
            settings.curfewWarn = curfewWarn / 3600
            settings.curfewStart = curfewStart / 3600
            settings.curfewEnd = curfewEnd / 3600
            AppState.shared.setupNotifications()
        }
    }
}

struct CurfewSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        CurfewSettingsView()
    }
}
