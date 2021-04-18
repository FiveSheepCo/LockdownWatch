//
//  LockdownState.swift
//  LockdownWatch WatchKit Extension
//
//  Created by Marco Quinten Privat on 18.04.21.
//

import Foundation

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
}
