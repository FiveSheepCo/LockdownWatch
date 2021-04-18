//
//  HomeView.swift
//  LockdownWatch WatchKit Extension
//
//  Created by Marco Quinten Privat on 17.04.21.
//

import SwiftUI
import WatchKit
import UserNotifications

struct HomeView: View {
    let config = Config.shared
    @ObservedObject var model = HomeViewModel()
    @ObservedObject var state: AppState = .shared
    
    var body: some View {
        VStack {
            Gauge(
                value: model.currentHour,
                in: 0...24,
                label: {
                    Text(model.currentTime)
                },
                currentValueLabel: { Text(model.lockdownState.emoji) }
            )
            .gaugeStyle(
                CircularGaugeStyle(tint: config.gaugeGradient)
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .scaleEffect(2.0)
            Text(model.lockdownState.text)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
