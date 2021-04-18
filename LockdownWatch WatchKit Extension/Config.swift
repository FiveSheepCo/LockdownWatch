//
//  Config.swift
//  LockdownWatch WatchKit Extension
//
//  Created by Marco Quinten Privat on 18.04.21.
//

import Foundation
import SwiftUI

struct Config {
    static let shared: Config = .init()
    
    let curfewWarn = [
        DoubleTime.get(hour: 20, minute: 30),
        DoubleTime.get(hour: 21, minute: 00)
    ]
    
    let curfewActive = [
        DoubleTime.get(hour: 21, minute: 00),
        DoubleTime.get(hour: 05, minute: 00)
    ]
    
    init() {
    }
    
    var gaugeGradient: Gradient {
        var colorStops: [Gradient.Stop] = []
        
        colorStops.append(.init(color: .red, location: 0))
        colorStops.append(.init(color: .red, location: CGFloat(curfewActive[1] / 24.0)))
        colorStops.append(.init(color: .green, location: CGFloat(curfewActive[1] / 24.0)))
        colorStops.append(.init(color: .green, location: CGFloat(curfewWarn[0] / 24.0)))
        colorStops.append(.init(color: .yellow, location: CGFloat(curfewWarn[0] / 24.0)))
        colorStops.append(.init(color: .yellow, location: CGFloat(curfewWarn[1] / 24.0)))
        colorStops.append(.init(color: .red, location: CGFloat(curfewActive[0] / 24.0)))
        colorStops.append(.init(color: .red, location: 1))
        
        return Gradient(stops: colorStops)
    }
    
    func lockdownState(for timeNow: Double) -> LockdownState {
        if isCurfewActive(timeNow) {
            return .lockdown
        } else if isCurfewWarn(timeNow) {
            return .lockdownSoon
        } else {
            return .freedom
        }
    }
    
    private func isCurfewActive(_ timeNow: Double) -> Bool {
        return timeNow >= curfewActive[0] || timeNow <= curfewActive[1]
    }
    
    private func isCurfewWarn(_ timeNow: Double) -> Bool {
        return timeNow >= curfewWarn[0] && timeNow <= curfewWarn[1]
    }
}
