//
//  City.swift
//  WeatherCities
//
//  Created by Artur Bagautdinov on 28.12.2025.
//

import Foundation

struct City: Identifiable, Hashable {
    let id = UUID()
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
        City(name: "Kaliningrad", latitude: 54.7104, longitude: 20.4522)
    ]

}
