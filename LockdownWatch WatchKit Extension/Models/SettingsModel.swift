//
//  SettingsModel.swift
//  LockdownWatch WatchKit Extension
//
//  Created by Marco Quinten Privat on 18.04.21.
//

import Foundation

private let defaults = UserDefaults.standard

class SettingsModel: ObservableObject {
    static let shared = SettingsModel()
    
    struct Keys {
        struct Region {
            static let country = "region.country"
            static let state = "region.state"
        }
        struct Curfew {
            static let start = "curfew.start"
            static let warn = "curfew.warn"
            static let end = "curfew.end"
        }
    }
    
    private init() {}
    
    @Published var country: String? = defaults.string(forKey: Keys.Region.country) {
        didSet {
            defaults.setValue(country, forKey: Keys.Region.country)
        }
    }
    
    @Published var state: String? = defaults.string(forKey: Keys.Region.state) {
        didSet {
            defaults.setValue(state, forKey: Keys.Region.state)
        }
    }
    
    @Published var curfewWarn: Double? = defaults.double(forKey: Keys.Curfew.warn) {
        didSet {
            defaults.setValue(curfewWarn, forKey: Keys.Curfew.warn)
        }
    }
    
    @Published var curfewStart: Double? = defaults.double(forKey: Keys.Curfew.start) {
        didSet {
            defaults.setValue(curfewStart, forKey: Keys.Curfew.start)
        }
    }
    
    @Published var curfewEnd: Double? = defaults.double(forKey: Keys.Curfew.end) {
        didSet {
            defaults.setValue(curfewEnd, forKey: Keys.Curfew.end)
        }
    }
}
