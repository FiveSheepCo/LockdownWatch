//
//  HomeViewModel.swift
//  LockdownWatch WatchKit Extension
//
//  Created by Marco Quinten Privat on 17.04.21.
//

import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {
    private var timer: Timer? = nil
    
    @Published var lockdownState: LockdownState = .freedom
    @Published var currentHour: Double = 0
    @Published var currentTime: String = "..."
    
    init() {
        self.update()
        self.timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { timer in
            self.update()
        }
    }
    
    private func update() {
        let now = Date()
        let calendar = Calendar.current
        let componentsNow = calendar.dateComponents([.day, .hour, .minute], from: now)
        
        if componentsNow.hour! >= 21 || componentsNow.hour! < 5 {
            lockdownState = .lockdown
        } else if componentsNow.hour! >= 20 && componentsNow.minute! >= 30 {
            lockdownState = .lockdownSoon
        } else {
            lockdownState = .freedom
        }
        
        currentHour = Double(componentsNow.hour!) + Double(componentsNow.minute!) / 60.0
        currentTime = "\(componentsNow.hour!):\(componentsNow.minute!)"
    }
    
    deinit {
        if let timer = self.timer {
            timer.invalidate()
        }
    }
}
