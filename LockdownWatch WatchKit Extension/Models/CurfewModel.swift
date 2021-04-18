//
//  HomeViewModel.swift
//  LockdownWatch WatchKit Extension
//
//  Created by Marco Quinten Privat on 17.04.21.
//

import Foundation
import SwiftUI

class CurfewModel: ObservableObject {
    private var config: Config
    private var calendar: Calendar
    private var dateFormatter: DateFormatter
    private var timer: Timer?
    
    private var lastDateComponents: DateComponents?
    
    @Published var lockdownState: LockdownState = .indeterminate
    @Published var currentHour: Double = 0
    @Published var currentTime: String = "..."
    
    init() {
        self.config = .shared
        self.calendar = .current
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "HH:mm"
        self.lastDateComponents = nil
        
        self.fastUpdate()
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.fastUpdate()
        }
    }
    
    deinit {
        if let timer = self.timer {
            timer.invalidate()
        }
    }
    
    private func minuteChanged(_ a: DateComponents, _ b: DateComponents) -> Bool {
        a.hour! != b.hour! || a.minute! != b.minute!
    }
    
    /// This update function is supposed to be called every second.
    /// It has to be very fast and efficient to avoid draining the battery.
    private func fastUpdate() {
        let now = Date()
        let componentsNow = calendar.dateComponents([.day, .hour, .minute], from: now)
        let nowDouble = DoubleTime.get(hour: componentsNow.hour!, minute: componentsNow.minute!)
        
        if let dateComponents = self.lastDateComponents, minuteChanged(dateComponents, componentsNow) {
            update(now: now, nowDouble: nowDouble)
        } else if lastDateComponents == nil {
            update(now: now, nowDouble: nowDouble)
        }
        
        self.lastDateComponents = componentsNow
    }
    
    /// This more expensive update function is only called when the hour or minute changes.
    private func update(now: Date, nowDouble: Double) {
        currentHour = nowDouble
        let previousLockdownState = lockdownState
        lockdownState = config.lockdownState(for: nowDouble)
        
        if previousLockdownState != .lockdown && previousLockdownState != .indeterminate && lockdownState == .lockdown {
            SoundPlayer.playSound()
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        currentTime = dateFormatter.string(from: now)
    }
}
