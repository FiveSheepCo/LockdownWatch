//
//  TimePicker.swift
//  LockdownWatch WatchKit Extension
//
//  Created by Marco Quinten Privat on 23.04.21.
//

import SwiftUI

struct TimePicker: View {
    @ObservedObject var timeComponent: TimeComponent
    
    @State private var hourFocused: Bool = false
    @State private var minuteFocused: Bool = false

    static let formatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        return formatter
    }()

    var body: some View {
        HStack {
            Text("\(timeComponent.wholeHour, specifier: "%02d")")
                .font(.title3)
                .focusable(true, onFocusChange: { focused in
                    hourFocused = focused
                })
                .digitalCrownRotation(
                    $timeComponent.hour,
                    from: 0,
                    through: 24,
                    by: 1,
                    sensitivity: .medium,
                    isContinuous: false,
                    isHapticFeedbackEnabled: true
                )
                .padding(.horizontal, 4)
                .border(Color.accentColor, width: hourFocused ? 2 : 0)
                .cornerRadius(3)
            Text(":")
            Text("\(timeComponent.wholeMinute, specifier: "%02d")")
                .font(.title3)
                .focusable(true, onFocusChange: { focused in
                    minuteFocused = focused
                })
                .digitalCrownRotation(
                    $timeComponent.minute,
                    from: 0,
                    through: 59,
                    by: 1,
                    sensitivity: .medium,
                    isContinuous: false,
                    isHapticFeedbackEnabled: true
                )
                .padding(.horizontal, 4)
                .border(Color.accentColor, width: minuteFocused ? 2 : 0)
                .cornerRadius(3)
        }
    }
}
