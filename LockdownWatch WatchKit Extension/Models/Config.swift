//
//  Config.swift
//  LockdownWatch WatchKit Extension
//
//  Created by Marco Quinten Privat on 18.04.21.
//

import Foundation
import SwiftUI

class Config: ObservableObject {
    static let shared: Config = .init()
    
    let settings: SettingsModel = .shared
    
    private init() {
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
        guard settings.curfewEnabled else { return false }
        return timeNow >= settings.curfewStart || timeNow <= settings.curfewEnd
    }
    
    private func isCurfewWarn(_ timeNow: Double) -> Bool {
        guard settings.curfewEnabled else { return false }
        return timeNow >= settings.curfewWarn && timeNow <= settings.curfewStart
    }
}
