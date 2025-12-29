//
//  WeatherResponse.swift
//  WeatherApp
//
//  Created by Ляйсан
//

import Foundation
import SwiftUI

struct WeatherResponse: Codable {
    let current: CurrentWeather
}

struct CurrentWeather: Codable {
    let temperature2m: Double
    let weatherCode: Int
    
    enum CodingKeys: String, CodingKey {
        case temperature2m = "temperature_2m"
        case weatherCode = "weather_code"
    }
}

extension CurrentWeather {
    var weatherDescription: String {
            switch weatherCode {
            case 0: return "Clear sky"
            case 1: return "Mainly clear"
            case 2: return "Partly cloudy"
            case 3: return "Overcast"
            case 45, 48: return "Fog"
            case 51, 53, 55: return "Drizzle"
            case 56, 57: return "Freezing drizzle"
            case 61, 63, 65: return "Rain"
            case 66, 67: return "Freezing rain"
            case 71, 73, 75: return "Snow"
            case 77: return "Snow grains"
            case 80, 81, 82: return "Rain showers"
            case 85, 86: return "Snow showers"
            case 95: return "Thunderstorm"
            case 96, 99: return "Thunderstorm with hail"
            default: return "Unknown"
            }
        }
    
    var weatherSymbol: String {
            switch weatherCode {
            case 0: return "sun.max.fill"
            case 1, 2: return "cloud.sun.fill"
            case 3: return "cloud.fill"
            case 45, 48: return "cloud.fog.fill"
            case 51...57: return "cloud.drizzle.fill"
            case 61...67: return "cloud.rain.fill"
            case 71...77: return "cloud.snow.fill"
            case 80...82: return "cloud.heavyrain.fill"
            case 85...86: return "cloud.snow.fill"
            case 95...99: return "cloud.bolt.rain.fill"
            default: return "cloud.fill"
            }
        }
    
    var weatherSymbolColors: [Color] {
            switch weatherCode {
            case 0: return [.yellow, .yellow]
            case 1, 2: return [.white, .yellow]
            case 45, 48: return [.white, .gray.opacity(0.7)]
            case 51...57: return [.white, .blue]
            case 61...67: return [.white, .blue]
            case 71...77: return [.white, .cyan.opacity(0.8)]
            case 80...82: return [.white, .blue]
            case 85...86: return [.white, .cyan]
            case 95...99: return [.white, .yellow]
            default: return [.white, .white]
            }
        }
    
    var tempratureColors: [Color] {
        switch temperature2m {
        case ..<(-20): return [.tBlue]
        case -20..<0: return [.tBlue, .tLightBlue]
        case 0..<1: return [.tLightBlue]
        case 1..<7: return [.tLightBlue, .tUltraLightBlue]
        case 7..<13: return [.tUltraLightBlue, .tTurquoise]
        case 13..<15: return [.tGreen]
        case 15..<17: return [.tGreen, .tYellow]
        case 17..<21: return [.tYellow, .tLightOrange]
        case 21..<25: return [.tYellow, .tLightOrange, .tOrange]
        case 25..<30: return [.tOrange, .tDarkOrange]
        case 30...:  return [.tRed]
        default: return [.tLightBlue]
        }
    }
}
