//
//  DoubleTime.swift
//  LockdownWatch WatchKit Extension
//
//  Created by Marco Quinten Privat on 18.04.21.
//

import Foundation

struct DoubleTime {
    static func get(hour h: Int, minute m: Int) -> Double {
        return Double(h) + Double(m) / 60.0
    }
}
