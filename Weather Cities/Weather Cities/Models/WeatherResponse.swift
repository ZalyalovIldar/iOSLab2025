//
//  WeatherResponse.swift
//  Weather Cities
//
//  Created by Azamat Zakirov on 30.12.2025.
//

import Foundation

struct WeatherResponse: Codable {
    let main: Main
    let wind: Wind
    let weather: [Weather]
    let name: String
}

struct Main: Codable {
    let temp: Double
    let feelsLike: Double
    let humidity: Int
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case humidity
    }
}

struct Wind: Codable {
    let speed: Double
    let deg: Int
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}
