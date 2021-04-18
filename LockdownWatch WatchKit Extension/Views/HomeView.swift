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
    let config = Config.shared
    
    @ObservedObject var settings: SettingsModel = .shared
    @ObservedObject var state: AppState = .shared
    @ObservedObject var rkiFetcher = RKIFetcher.shared
    @ObservedObject var jhuFetcher = JHUFetcher.shared
    
    init() {
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Spacer()
            
            CurfewGauge()
            
            Spacer()
            
            VStack(alignment: .center, spacing: 2) {
                if let data = rkiFetcher.dataGermany, settings.country == "Germany" {
                    HStack(alignment: .center) {
                        Text("📈")
                        Text("IW \(Int(data.weekIncidence))")
                        Text("R \(data.r.value, specifier: "%.2f")")
                    }.frame(maxWidth: .infinity)
                }
            }.font(.system(size: 10)).frame(maxWidth: .infinity)
            
            Spacer()
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 60, repeats: true, block: { _ in
                self.rkiFetcher.fetch()
            })
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
