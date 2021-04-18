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
    
    @ObservedObject var model = HomeViewModel()
    @ObservedObject var state: AppState = .shared
    @ObservedObject var rkiFetcher = RKIFetcher()
    
    init() {
        rkiFetcher.fetch()
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Spacer()
            
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
            .scaleEffect(2.0)
            
            Text(model.lockdownState.text)
            
            Spacer()
            
            VStack(alignment: .center, spacing: 2) {
                if let data = rkiFetcher.dataGermany {
                    HStack(alignment: .center) {
                        Text("📈")
                        Text("IW \(Int(data.weekIncidence))")
                        Text("R \(data.r.value, specifier: "%.2f")")
                    }.frame(maxWidth: .infinity, maxHeight: 20)
                }
                
                if let data = rkiFetcher.vaxData {
                    HStack(alignment: .center) {
                        Text("💉")
                        Text("\(data.data.quote * 100, specifier: "%.2f")% first vax")
                    }.frame(maxWidth: .infinity, maxHeight: 20)
                }
            }.font(.footnote).frame(maxWidth: .infinity)
            
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
