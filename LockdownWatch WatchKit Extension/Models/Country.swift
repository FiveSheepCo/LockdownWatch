//
//  Country.swift
//  LockdownWatch WatchKit Extension
//
//  Created by Marco Quinten Privat on 18.04.21.
//

import Foundation

enum Country: CaseIterable, Identifiable {
    case usa
    case germany
    case france
    case romania
    
    var id: String {
        switch self {
        case .germany: return "Germany"
        case .usa: return "US"
        case .france: return "France"
        case .romania: return "Romania"
        }
    }
    
    var name: String {
        switch self {
        case .germany: return "Germany"
        case .usa: return "USA"
        case .france: return "France"
        case .romania: return "Romania"
        }
    }
    
    var states: [String] {
        switch self {
        case .germany:
            return [
                "Baden-Wurttemberg",
                "Bayern",
                "Berlin",
                "Brandenburg",
                "Bremen",
                "Hamburg",
                "Hessen",
                "Mecklenburg-Vorpommern",
                "Niedersachsen",
                "Nordrhein-Westfalen",
                "Rheinland-Pfalz",
                "Saarland",
                "Sachsen",
                "Sachsen-Anhalt",
                "Schleswig-Holstein",
                "Thuringen",
                "Unknown",
            ]
        case .usa:
            return [
                "Alabama",
                "Alaska",
                "Arizona",
                "Arkansas",
                "California",
                "Colorado",
                "Connecticut",
                "Delaware",
                "Diamond Princess",
                "District of Columbia",
                "Florida",
                "Georgia",
                "Grand Princess",
                "Guam",
                "Hawaii",
                "Idaho",
                "Illinois",
                "Indiana",
                "Iowa",
                "Kansas",
                "Kentucky",
                "Louisiana",
                "Maine",
                "Maryland",
                "Massachusetts",
                "Michigan",
                "Minnesota",
                "Mississippi",
                "Missouri",
                "Montana",
                "Nebraska",
                "Nevada",
                "New Hampshire",
                "New Jersey",
                "New Mexico",
                "New York",
                "North Carolina",
                "North Dakota",
                "Northern Mariana Islands",
                "Ohio",
                "Oklahoma",
                "Oregon",
                "Pennsylvania",
                "Puerto Rico",
                "Rhode Island",
                "South Carolina",
                "South Dakota",
                "Tennessee",
                "Texas",
                "Utah",
                "Vermont",
                "Virginia",
                "Washington",
                "West Virginia",
                "Wisconsin",
                "Wyoming",
            ]
        default:
            return []
        }
    }
}
