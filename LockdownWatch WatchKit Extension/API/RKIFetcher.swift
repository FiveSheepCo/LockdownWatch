//
//  RKIFetcher.swift
//  LockdownWatch WatchKit Extension
//
//  Created by Marco Quinten Privat on 18.04.21.
//

import Foundation
import SwiftUI

let URL_RKI_GERMANY = URL(string: "https://api.corona-zahlen.org/germany")!
let URL_RKI_VACCINATIONS = URL(string: "https://api.corona-zahlen.org/vaccinations")!

struct RKIDataGermany: Codable {
    struct Delta: Codable {
        var cases: Int
        var deaths: Int
        var recovered: Int
    }
    
    struct R: Codable {
        var value: Double
        var date: String
    }
    
    let cases: Int
    let deaths: Int
    let recovered: Int
    let weekIncidence: Double
    let casesPer100k: Double
    let casesPerWeek: Double
    let delta: Delta
    let r: R
}

struct RKIVaxData: Codable {
    struct Data: Codable {
        struct SecondVaccination: Codable {
            let delta: Int
            let quote: Double
        }
        
        let delta: Int
        let quote: Double
        let secondVaccination: SecondVaccination
    }
    
    let data: Data
}

class RKIFetcher: ObservableObject {
    static let shared: RKIFetcher = .init()
    
    private let jsonDecoder = JSONDecoder()
    
    @Published var dataGermany: RKIDataGermany?
    @Published var vaxData: RKIVaxData?
    
    private init() {
        dataGermany = nil
        vaxData = nil
    }
    
    func fetch() {
        fetchGermany()
        fetchVaccinations()
    }
    
    private func fetchGermany() {
        URLSession.shared.dataTask(with: URL_RKI_GERMANY) { data, resp, err in
            
            // Validate response
            guard err == nil else { return }
            guard let data = data else { return }
            guard (resp as? HTTPURLResponse)?.statusCode == 200 else { return }
            
            // Deserialize JSON
            if let data = try? self.jsonDecoder.decode(RKIDataGermany.self, from: data) {
                DispatchQueue.main.async {
                    self.dataGermany = data
                }
            } else {
                print("FAILED TO DECODE DATA")
            }
        }.resume()
    }
    
    private func fetchVaccinations() {
        URLSession.shared.dataTask(with: URL_RKI_VACCINATIONS) { data, resp, err in
            
            // Validate response
            guard err == nil else { return }
            guard let data = data else { return }
            guard (resp as? HTTPURLResponse)?.statusCode == 200 else { return }
            
            // Deserialize JSON
            if let data = try? self.jsonDecoder.decode(RKIVaxData.self, from: data) {
                DispatchQueue.main.async {
                    self.vaxData = data
                }
            } else {
                print("FAILED TO DECODE DATA")
            }
        }.resume()
    }
}
