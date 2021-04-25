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
        
        struct State: Codable {
            let name: String
            let delta: Int
            let quote: Double
            let secondVaccination: SecondVaccination
        }
        
        struct StateDict: Codable {
            let BW: State
            let BY: State
            let BE: State
            let BB: State
            let HB: State
            let HH: State
            let HE: State
            let MV: State
            let NI: State
            let NW: State
            let RP: State
            let SL: State
            let SN: State
            let ST: State
            let SH: State
            let TH: State
            
            var allStates: [State] {
                [BW, BY, BE, BB, HB, HH, HE, MV, NI, NW, RP, SL, SN, ST, SH, TH]
            }
        }
        
        let delta: Int
        let quote: Double
        let secondVaccination: SecondVaccination
        let states: StateDict
    }
    
    let data: Data
}

struct RKISpecificVaxData {
    struct SecondVaccination {
        let quote: Double
    }
    
    let quote: Double
    let secondVaccination: SecondVaccination
}

class RKIFetcher: ObservableObject {
    static let shared: RKIFetcher = .init()
    
    private let jsonDecoder = JSONDecoder()
    
    @Published var dataGermany: RKIDataGermany?
    
    private var vaxData: RKIVaxData?
    @Published var specificVaxData: RKISpecificVaxData?
    
    private init() {
        dataGermany = nil
        vaxData = nil
    }
    
    func fetch() {
        fetchGermany()
        fetchVaccinations()
    }
    
    func rehash() {
        func rkiNormalized(state: String) -> String {
            state
                .replacingOccurrences(of: "ü", with: "u")
                .replacingOccurrences(of: "ä", with: "a")
                .replacingOccurrences(of: "ö", with: "o")
                .replacingOccurrences(of: "ß", with: "ss")
        }
        guard let vaxData = self.vaxData else { return }
        if let state = SettingsModel.shared.state {
            if let stateData = vaxData.data.states.allStates.first(where: { value in
                rkiNormalized(state: value.name) == state
            }) {
                specificVaxData = RKISpecificVaxData(
                    quote: stateData.quote,
                    secondVaccination: RKISpecificVaxData.SecondVaccination(
                        quote: stateData.secondVaccination.quote
                    )
                )
                return
            }
        }
        specificVaxData = RKISpecificVaxData(
            quote: vaxData.data.quote,
            secondVaccination: RKISpecificVaxData.SecondVaccination(
                quote: vaxData.data.secondVaccination.quote
            )
        )
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
                print("[RKIFetcher] FAILED TO DECODE GERMANY DATA")
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
                    self.rehash()
                }
            } else {
                print("[RKIFetcher] FAILED TO DECODE VAX DATA")
            }
        }.resume()
    }
}
