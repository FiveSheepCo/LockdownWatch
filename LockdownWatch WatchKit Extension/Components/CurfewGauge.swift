//
//  CurfewGauge.swift
//  LockdownWatch WatchKit Extension
//
//  Created by Marco Quinten Privat on 18.04.21.
//

import SwiftUI

struct CurfewGauge: View {
    @ObservedObject var config: Config = .shared
    @ObservedObject var model = CurfewModel()
    
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
                CircularGaugeStyle(tint: config.gaugeGradient)
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
