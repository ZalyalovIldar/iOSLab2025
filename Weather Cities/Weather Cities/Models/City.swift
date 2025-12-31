//
//  City.swift
//  Weather Cities
//
//  Created by Azamat Zakirov on 30.12.2025.
//

import Foundation

struct City: Identifiable, Codable {
    let id = UUID()
    let name: String
    let latitude: Double
    let longitude: Double
    
    enum CodingKeys: String, CodingKey {
        case name, latitude, longitude
    }
}

extension City {
    static let defaultCities: [City] = [
        City(name: "Moscow", latitude: 55.7558, longitude: 37.6173),
        City(name: "London", latitude: 51.5074, longitude: -0.1278),
        City(name: "New York", latitude: 40.7128, longitude: -74.0060),
        City(name: "Tokyo", latitude: 35.6762, longitude: 139.6503),
        City(name: "Paris", latitude: 48.8566, longitude: 2.3522),
        City(name: "Berlin", latitude: 52.5200, longitude: 13.4050),
        City(name: "Sydney", latitude: -33.8688, longitude: 151.2093),
        City(name: "Dubai", latitude: 25.2048, longitude: 55.2708)
    ]
}
