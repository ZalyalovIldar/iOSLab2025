//
//  CityWeather.swift
//  WeatherCities
//
//  Created by Artur Bagautdinov on 28.12.2025.
//

import Foundation
import SwiftUI

struct CityWeather: Identifiable, Hashable {
    
    var id: String { city.id }
    let city: City
    let temperatureC: Double
    let windSpeedKmh: Double
    let windDirectionDeg: Double
    let weatherCode: Int
    let observationTime: String
}

extension CityWeather {
    var temperatureText: String {
        String(format: "%.1f°C", temperatureC)
    }

    var windText: String {
        String(format: "%.0f km/h", windSpeedKmh)
    }

    var directionText: String {
        String(format: "%.0f°", windDirectionDeg)
    }

    var codeDescription: String {
        switch weatherCode {
        case 0: return "Clear"
        case 1,2,3: return "Partly cloudy"
        case 45,48: return "Fog"
        case 51,53,55: return "Drizzle"
        case 61,63,65: return "Rain"
        case 71,73,75: return "Snow"
        case 80,81,82: return "Showers"
        case 95: return "Thunderstorm"
        default: return "Code \(weatherCode)"
        }
    }

    var symbolName: String {
        switch weatherCode {
        case 0: return "sun.max"
        case 1,2,3: return "cloud.sun"
        case 45,48: return "cloud.fog"
        case 51,53,55: return "cloud.drizzle"
        case 61,63,65: return "cloud.rain"
        case 71,73,75: return "cloud.snow"
        case 80,81,82: return "cloud.heavyrain"
        case 95: return "cloud.bolt.rain"
        default: return "questionmark.circle"
        }
    }
    
    var compassDirection: String {
        switch windDirectionDeg {
        case 337.5...360, 0..<22.5: return "N"
        case 22.5..<67.5: return "NE"
        case 67.5..<112.5: return "E"
        case 112.5..<157.5: return "SE"
        case 157.5..<202.5: return "S"
        case 202.5..<247.5: return "SW"
        case 247.5..<292.5: return "W"
        case 292.5..<337.5: return "NW"
        default: return ""
        }
    }
    
    var temperatureColor: Color {
        switch temperatureC {
        case ..<0:
            return .blue
        case 0..<15:
            return .cyan
        case 15..<25:
            return .primary
        case 25..<35:
            return .red
        default:
            return .red
        }
    }
}
