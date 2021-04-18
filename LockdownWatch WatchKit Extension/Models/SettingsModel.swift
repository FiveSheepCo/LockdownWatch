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
}
