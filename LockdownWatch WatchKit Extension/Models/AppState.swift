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
        let settings = SettingsModel.shared
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [uuidLockdownSoon, uuidLockdown])
        
        guard let warnTime = settings.curfewWarn, let startTime = settings.curfewStart else {
            return
        }
        
        let warnTimeH = Int(warnTime - warnTime.truncatingRemainder(dividingBy: 1))
        let warnTimeM = Int(warnTime.truncatingRemainder(dividingBy: 1) * 60)
        
        let startTimeH = Int(startTime - startTime.truncatingRemainder(dividingBy: 1))
        let startTimeM = Int(startTime.truncatingRemainder(dividingBy: 1) * 60)
        
        print("[Setup/Notification] LockdownSoon at \(warnTimeH):\(warnTimeM)")
        print("[Setup/Notification] Lockdown at \(startTimeH):\(startTimeM)")
        
        let contentLockdownSoon = UNMutableNotificationContent()
        contentLockdownSoon.title = "WARNING"
        contentLockdownSoon.body = "The purge will start soon."
        contentLockdownSoon.sound = UNNotificationSound.default
        let contentLockdown = UNMutableNotificationContent()
        contentLockdown.title = "DANGER"
        contentLockdown.body = "The purge has started."
        contentLockdown.sound = UNNotificationSound.defaultCritical
        
        let componentLockdownSoon = DateComponents(hour: warnTimeH, minute: warnTimeM, second: 0)
        let componentLockdown = DateComponents(hour: startTimeH, minute: startTimeM, second: 0)
        
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
        
        center.add(requestLockdownSoon) { error in
            print("[Setup/Notification] LockdownSoon: \(error == nil ? "Success" : "Error")")
        }
        center.add(requestLockdown) { error in
            print("[Setup/Notification] Lockdown: \(error == nil ? "Success" : "Error")")
        }
    }
}
