//
//  WeatherResponse.swift
//  Lesson8
//
//  Created by Timur Minkhatov on 26.12.2025.
//

import Foundation

struct WeatherResponse: Codable {
    let current: CurrentWeather
}

struct CurrentWeather: Codable {
    let temperature2m: Double
    let windSpeed10m: Double
    let weatherCode: Int
    
    enum CodingKeys: String, CodingKey {
        case temperature2m = "temperature_2m"
        case windSpeed10m = "wind_speed_10m"
        case weatherCode = "weather_code"
    }
}
