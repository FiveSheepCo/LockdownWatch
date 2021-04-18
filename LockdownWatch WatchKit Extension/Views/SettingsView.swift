//
//  SettingsView.swift
//  LockdownWatch WatchKit Extension
//
//  Created by Marco Quinten Privat on 17.04.21.
//

import SwiftUI

struct SettingsEntry<Destination: View>: View {
    let symbol: String
    let color: Color
    let name: String
    let destination: () -> Destination
    
    init(symbol: String, name: String, color: Color, @ViewBuilder destination: @escaping () -> Destination) {
        self.symbol = symbol
        self.color = color
        self.name = name
        self.destination = destination
    }
    
    var body: some View {
        NavigationLink(destination: self.destination()) {
            HStack {
                RoundedRectangle(cornerRadius: 6)
                    .fill(color)
                    .aspectRatio(1.0, contentMode: .fit)
                    .frame(maxWidth: 24, maxHeight: 24)
                    .overlay(Image(systemName: symbol), alignment: .center)
                    .padding(.trailing, 4)
                Text(name)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundColor(.white)
                    .opacity(0.5)
                    .padding(.trailing, 4)
            }
        }
    }
}

struct SettingsView: View {
    struct FooterSection: View {
        var body: some View {
            Section(
                footer: HStack {
                    Spacer()
                    VStack {
                        Text("Made with ❤️")
                        Image("Quintschaf")
                            .renderingMode(.template)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 28)
                    }
                    Spacer()
                },
                content: { EmptyView() }
            ).font(.system(size: 12))
        }
    }
    
    var body: some View {
        List {
            SettingsEntry(symbol: "globe", name: "Region", color: .blue) {
                RegionSettingsView()
            }
            SettingsEntry(symbol: "timer", name: "Curfew", color: .purple) {
                CurfewSettingsView()
            }
            FooterSection()
        }.navigationBarTitle("Settings")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
