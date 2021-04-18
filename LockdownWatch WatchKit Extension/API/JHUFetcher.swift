//
//  JHUFetcher.swift
//  LockdownWatch WatchKit Extension
//
//  Created by Marco Quinten Privat on 18.04.21.
//

import Foundation
import SwiftUI
import CodableCSV

struct JHUData: Codable {
    enum CodingKeys: Int, CodingKey {
        case fips = 0
        case admin2 = 1
        case state = 2
        case country = 3
        case lastUpdate = 4
        case lat = 5
        case long = 6
        case confirmed = 7
        case deaths = 8
        case recovered = 9
        case active = 10
        case combinedKey = 11
        case incidentRate = 12
        case caseFatalityRatio = 13
    }
    
    let fips: Int?
    let admin2: String?
    let state: String?
    let country: String?
    let lastUpdate: String?
    let lat: Double?
    let long: Double?
    let confirmed: Int?
    let deaths: Int?
    let recovered: Int?
    let active: Int?
    let combinedKey: String?
    let incidentRate: Double?
    let caseFatalityRatio: Double?
}

struct JHUAggregateData {
    var country: String
    var state: String
    var confirmed: Int
    var deaths: Int
    var recovered: Int
    var active: Int
    var incidentRate: Double
    var caseFatalityRatio: Double
}

class JHUFetcher: ObservableObject {
    static let shared: JHUFetcher = .init()
    
    private let settings: SettingsModel = .shared
    private var rawData: [JHUData]?
    
    private init() {}
    
    var url: URL {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-YYYY"
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        let filename = dateFormatter.string(from: yesterday)
        print("[JHUFetcher] Record: \(filename).csv")
        let baseUrl = "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports"
        let url = "\(baseUrl)/\(filename).csv"
        return URL(string: url)!
    }
    
    @Published var data: JHUAggregateData? = nil
    
    func rehash() {
        self.data = aggregateData(country: settings.country ?? "US", state: settings.state ?? "All")
    }
    
    private func aggregateData(country: String, state: String) -> JHUAggregateData? {
        guard let data = self.rawData else { return nil }
        let matchingData = data.filter { $0.country == country && (state == "All" || $0.state == state) }
        var aggregateData = JHUAggregateData(
            country: country,
            state: state,
            confirmed: 0,
            deaths: 0,
            recovered: 0,
            active: 0,
            incidentRate: 0,
            caseFatalityRatio: 0
        )
        for dp in matchingData {
            aggregateData.confirmed += dp.confirmed ?? 0
            aggregateData.deaths += dp.deaths ?? 0
            aggregateData.recovered += dp.recovered ?? 0
            aggregateData.active += dp.active ?? 0
            aggregateData.incidentRate += dp.incidentRate ?? 0
            aggregateData.caseFatalityRatio += dp.caseFatalityRatio ?? 0
        }
        aggregateData.incidentRate /= max(1, Double(matchingData.filter { $0.incidentRate != nil }.count))
        aggregateData.caseFatalityRatio /= Double(matchingData.filter { $0.caseFatalityRatio != nil }.count)
        return aggregateData
    }
    
    func fetch() {
        URLSession.shared.dataTask(with: url) { data, resp, err in
            
            // Validate response
            guard err == nil else {
                print("[JHUFetcher] Error: \(err.debugDescription)")
                return
            }
            guard let data = data else {
                print("[JHUFetcher] Error: Unable to fetch data.")
                return
            }
            guard (resp as? HTTPURLResponse)?.statusCode == 200 else {
                print("[JHUFetcher] Error: Got status \((resp as? HTTPURLResponse)?.statusCode ?? -1)")
                return
            }
            
            // Deserialize CSV
            var desConfig = CSVDecoder.Configuration()
            desConfig.decimalStrategy = .locale(Locale.init(identifier: "en_US"))
            desConfig.encoding = .ascii
            desConfig.delimiters.field = ","
            desConfig.delimiters.row = "\n"
            desConfig.headerStrategy = .firstLine
            print("Decoding...")
            if let data = try? CSVDecoder(configuration: desConfig).decode([JHUData].self, from: data) {
                print("Done!")
                DispatchQueue.main.async {
                    self.rawData = data
                    self.rehash()
                }
            } else {
                print("[JHUFetcher] Error: Unable to decode CSV.")
            }
        }.resume()
    }
}
