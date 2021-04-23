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
            }
        )
    }
    
    var body: some View {
        VStack {
            Picker("Country", selection: countryBinding) {
                ForEach(Country.allCases, id: \.id) { country in
                    Text(country.name).tag(country)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .defaultWheelPickerItemHeight(24)
            .frame(height: 70)
            
            if !countryBinding.wrappedValue.states.isEmpty {
                Picker("Province/State", selection: stateBinding) {
                    ForEach(["All"] + countryBinding.wrappedValue.states, id: \.self) { state in
                        Text(state).tag(state)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .defaultWheelPickerItemHeight(24)
            } else {
                Text("No regions available.")
            }
            
            Spacer()
        }
        .navigationTitle("Region")
        .onDisappear {
            JHUFetcher.shared.rehash()
        }
    }
}

struct RegionSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        RegionSettingsView()
    }
}
