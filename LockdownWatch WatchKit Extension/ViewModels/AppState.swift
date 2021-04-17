//
//  AppState.swift
//  LockdownWatch WatchKit Extension
//
//  Created by Marco Quinten Privat on 17.04.21.
//

import Foundation
import SwiftUI
import UserNotifications

let uuidLockdownSoon: String = "75b1d180-4d5d-40d7-9f83-653bedef47e0"
let uuidLockdown: String = "e21ec438-8412-4888-ba75-c04239d5bf3f"

class AppState: ObservableObject {
    static let shared: AppState = .init()
    
    @Published var notificationAccess: Bool = false
    
    private init() {}
    
    func requestPermissions() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                self.notificationAccess = granted && error == nil
            }
        }
    }
    
    func setupNotifications() {
        let center = UNUserNotificationCenter.current()
        
        let contentLockdownSoon = UNMutableNotificationContent()
        contentLockdownSoon.title = "WARNING"
        contentLockdownSoon.body = "The purge will start soon."
        contentLockdownSoon.sound = UNNotificationSound.default
        let contentLockdown = UNMutableNotificationContent()
        contentLockdown.title = "DANGER"
        contentLockdown.body = "The purge has started."
        contentLockdown.sound = UNNotificationSound.defaultCritical
        
        let componentLockdownSoon = DateComponents(hour: 20, minute: 30, second: 0)
        let componentLockdown = DateComponents(hour: 21, minute: 0, second: 0)
        
        let triggerLockdownSoon = UNCalendarNotificationTrigger(dateMatching: componentLockdownSoon, repeats: true)
        let triggerLockdown = UNCalendarNotificationTrigger(dateMatching: componentLockdown, repeats: true)
        
        let requestLockdownSoon = UNNotificationRequest(
            identifier: uuidLockdownSoon,
            content: contentLockdownSoon,
            trigger: triggerLockdownSoon
        )
        let requestLockdown = UNNotificationRequest(
            identifier: uuidLockdown,
            content: contentLockdown,
            trigger: triggerLockdown
        )
        
        center.removePendingNotificationRequests(withIdentifiers: [uuidLockdownSoon, uuidLockdown])
        
        center.add(requestLockdownSoon) { error in
            print("[Setup/Notification] LockdownSoon: \(error == nil ? "Success" : "Error")")
        }
        center.add(requestLockdown) { error in
            print("[Setup/Notification] Lockdown: \(error == nil ? "Success" : "Error")")
        }
    }
}
