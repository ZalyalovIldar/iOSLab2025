//
//  CityWeather.swift
//  Weather Cities
//
//  Created by Azamat Zakirov on 30.12.2025.
//

import Foundation

struct CityWeather: Identifiable {
    let id = UUID()
    let city: City
    let temperature: Double
    let feelsLike: Double
    let humidity: Int
    let windSpeed: Double
    let windDirection: Int
    let description: String
    let icon: String
}

extension CityWeather {
    var temperatureColor: String {
        temperature > 25 ? "red" : "blue"
    }
    
    var temperatureFormatted: String {
        String(format: "%.1f°C", temperature)
    }
    
    var windSpeedFormatted: String {
        String(format: "%.1f m/s", windSpeed)
    }
}
