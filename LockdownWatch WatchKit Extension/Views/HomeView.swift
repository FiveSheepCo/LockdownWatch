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
    @ObservedObject var model = HomeViewModel()
    @ObservedObject var state: AppState = .shared
    
    var body: some View {
        VStack {
            Gauge(
                value: Double(model.currentHour),
                in: 0...24,
                label: {
                    Text(model.currentTime)
                },
                currentValueLabel: { Text(model.lockdownState.emoji) },
                markedValueLabels: {
                    Text("Freedom").tag(5)
                    Text("Lockdown").tag(21)
                }
            )
            .gaugeStyle(
                CircularGaugeStyle(
                    tint: Gradient(
                        stops: [
                            .init(color: .red, location: 0), // 0h0m
                            .init(color: .red, location: 0.2),
                            .init(color: .green, location: 0.2), // 5h0m
                            .init(color: .green, location: 0.83), // 5h0m
                            .init(color: .yellow, location: 0.83), // 20h0m
                            .init(color: .yellow, location: 0.875),
                            .init(color: .red, location: 0.875), // 21h0m
                        ]
                    )
                )
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
