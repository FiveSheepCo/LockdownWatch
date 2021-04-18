//
//  RegionSettingsView.swift
//  LockdownWatch WatchKit Extension
//
//  Created by Marco Quinten Privat on 18.04.21.
//

import SwiftUI

struct RegionSettingsView: View {
    @ObservedObject var settings: SettingsModel = .shared
    
    var countryBinding: Binding<Country> {
        Binding.init(
            get: {
                let country = Country.allCases.first {
                    $0.id == settings.country ?? "US"
                } ?? .usa
                return country
            },
            set: { country in
                settings.country = country.id
                settings.state = "All"
                JHUFetcher.shared.rehash()
            }
        )
    }
    
    var stateBinding: Binding<String> {
        Binding.init(
            get: {
                settings.state ?? "All"
            },
            set: { state in
                settings.state = state
                JHUFetcher.shared.rehash()
            }
        )
    }
    
    var body: some View {
        VStack {
            Picker("Country", selection: countryBinding) {
                ForEach(Country.allCases) { country in
                    Text(country.name).tag(country)
                }
            }
            
            if !countryBinding.wrappedValue.states.isEmpty {
                Picker("Province/State", selection: stateBinding) {
                    ForEach(["All"] + countryBinding.wrappedValue.states, id: \.self) { state in
                        Text(state).tag(state)
                    }
                }
            }
        }.navigationTitle("Region")
    }
}

struct RegionSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        RegionSettingsView()
    }
}
