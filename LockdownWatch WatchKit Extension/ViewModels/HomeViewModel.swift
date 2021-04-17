//
//  HomeViewModel.swift
//  LockdownWatch WatchKit Extension
//
//  Created by Marco Quinten Privat on 17.04.21.
//

import Foundation
import SwiftUI

enum LockdownState {
    case freedom
    case lockdownSoon
    case lockdown
    
    var text: String {
        switch self {
        case .freedom: return "Freedom"
        case .lockdownSoon: return "Lockdown soon"
        case .lockdown: return "Lockdown"
        }
    }
    
    var emoji: String {
        switch self {
        case .freedom: return "👌"
        case .lockdownSoon: return "😰"
        case .lockdown: return "🚨"
        }
    }
    
    var color: Color {
        switch self {
        case .freedom: return .green
        case .lockdownSoon: return .yellow
        case .lockdown: return .red
        }
    }
}

extension Date {
    func isBefore(_ other: Date) -> Bool {
        other.timeIntervalSince1970 < self.timeIntervalSince1970
    }
    func isAfter(_ other: Date) -> Bool {
        other.timeIntervalSince1970 >= self.timeIntervalSince1970
    }
}

class HomeViewModel: ObservableObject {
    private var timer: Timer? = nil
    private var lastCheckDate: DateComponents? = nil
    
    @Published var lockdownState: LockdownState = .freedom
    @Published var currentHour: Int = 0
    @Published var currentTime: String = "..."
    
    init() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { timer in
            self.update()
        };
        self.update()
    }
    
    private func update() {
        let now = Date()
        let calendar = Calendar.current
        let componentsNow = calendar.dateComponents([.day, .hour, .minute], from: now)
        let componentsLockdownSoon = DateComponents(calendar: calendar, hour: 20, minute: 30)
        let componentsLockdown = DateComponents(calendar: calendar, hour: 21)
        
        if let dateLockdown = componentsLockdown.date, dateLockdown.isAfter(now) || componentsNow.hour! < 5 {
            lockdownState = .lockdown
        } else if let dateLockdownSoon = componentsLockdownSoon.date, componentsNow.hour! > 5 && dateLockdownSoon.isAfter(now) {
            lockdownState = .lockdownSoon
        } else {
            lockdownState = .freedom
        }
        
        if AppState.shared.notificationAccess {
            switch lockdownState {
            case .lockdownSoon:
                break
            case .lockdown:
                break
            default: ()
            }
        }
        
        lastCheckDate = componentsNow
        currentHour = componentsNow.hour!
        currentTime = "\(componentsNow.hour!):\(componentsNow.minute!)"
    }
    
    deinit {
        if let timer = self.timer {
            timer.invalidate()
        }
    }
}
