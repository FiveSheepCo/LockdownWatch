//
//  CurfewGauge.swift
//  LockdownWatch WatchKit Extension
//
//  Created by Marco Quinten Privat on 18.04.21.
//

import SwiftUI

struct CurfewGauge: View {
    @ObservedObject var config: Config = .shared
    @ObservedObject var settings: SettingsModel = .shared
    @ObservedObject var model = CurfewModel()
    
    var gaugeGradient: Gradient {
        var colorStops: [Gradient.Stop] = []
        
        let warn = min(24, settings.curfewWarn ?? 20.5)
        let start = min(24, settings.curfewStart ?? 21)
        let end = min(24, settings.curfewEnd ?? 5)
        
        colorStops.append(.init(color: .red, location: 0))
        colorStops.append(.init(color: .red, location: CGFloat(end / 24.0)))
        colorStops.append(.init(color: .green, location: CGFloat(end / 24.0)))
        colorStops.append(.init(color: .green, location: CGFloat(warn / 24.0)))
        colorStops.append(.init(color: .yellow, location: CGFloat(warn / 24.0)))
        colorStops.append(.init(color: .yellow, location: CGFloat(start / 24.0)))
        colorStops.append(.init(color: .red, location: CGFloat(start / 24.0)))
        colorStops.append(.init(color: .red, location: 1))
        
        return Gradient(stops: colorStops)
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Gauge(
                value: model.currentHour,
                in: 0...24,
                label: {
                    Text(model.currentTime)
                },
                currentValueLabel: { Text(model.lockdownState.emoji) }
            )
            .gaugeStyle(
                CircularGaugeStyle(tint: gaugeGradient)
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .scaleEffect(1.75)
            Text(model.lockdownState.text)
        }
    }
}

struct CurfewGauge_Previews: PreviewProvider {
    static var previews: some View {
        CurfewGauge()
    }
}
