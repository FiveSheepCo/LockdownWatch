//
//  TimeComponent.swift
//  LockdownWatch WatchKit Extension
//
//  Created by Marco Quinten Privat on 23.04.21.
//

import Foundation

class TimeComponent: ObservableObject {
    @Published var hour: Double
    @Published var minute: Double
    
    init(h: Double, m: Double) {
        hour = h
        minute = m
    }
    
    init(_ t: TimeInterval) {
        hour = trunc(t)
        minute = (t - trunc(t)) * 60
    }
    
    func update(_ t: TimeInterval) {
        hour = trunc(t)
        minute = (t - trunc(t)) * 60
    }
    
    var wholeHour: Int {
        Int(hour.rounded(.toNearestOrAwayFromZero))
    }
    
    var wholeMinute: Int {
        Int(minute.rounded(.toNearestOrAwayFromZero))
    }
    
    var time: TimeInterval {
        hour + minute / 60
    }
}
