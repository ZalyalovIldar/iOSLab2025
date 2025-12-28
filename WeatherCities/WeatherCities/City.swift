//
//  City.swift
//  WeatherCities
//
//  Created by Artur Bagautdinov on 28.12.2025.
//

import Foundation

struct City: Identifiable, Hashable {
    var id: String { name }
    let name: String
    let latitude: Double
    let longitude: Double
}

extension City {
    static let sample: [City] = [
        City(name: "Madrid", latitude: 40.4168, longitude: -3.7038),
        City(name: "Barcelona", latitude: 41.3874, longitude: 2.1686),
        City(name: "Valencia", latitude: 39.4699, longitude: -0.3763),
        City(name: "Seville", latitude: 37.3891, longitude: -5.9845),
        City(name: "Bilbao", latitude: 43.2630, longitude: -2.9350),
        City(name: "London", latitude: 51.5072, longitude: -0.1276),
        City(name: "Berlin", latitude: 52.5200, longitude: 13.4050),
        City(name: "Moscow", latitude: 55.7558, longitude: 37.6173),
        City(name: "Saint Petersburg", latitude: 59.9311, longitude: 30.3609),
        City(name: "Kazan", latitude: 55.7961, longitude: 49.1064),
        City(name: "Kaliningrad", latitude: 54.7104, longitude: 20.4522),
        City(name: "Dubai", latitude: 25.2048, longitude: 55.2708),
        City(name: "Riyadh", latitude: 24.7136, longitude: 46.6753),
        City(name: "Cairo", latitude: 30.0444, longitude: 31.2357),
        City(name: "Doha", latitude: 25.2854, longitude: 51.5310),
        City(name: "Mumbai", latitude: 19.0760, longitude: 72.8777),
        City(name: "Bangkok", latitude: 13.7563, longitude: 100.5018),
        City(name: "Singapore", latitude: 1.3521, longitude: 103.8198),   
        City(name: "Mexico City", latitude: 19.4326, longitude: -99.1332)
    ]

}
