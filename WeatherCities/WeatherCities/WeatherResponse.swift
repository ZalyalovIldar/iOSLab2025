//
//  WeatherResponse.swift
//  WeatherCities
//
//  Created by Artur Bagautdinov on 28.12.2025.
//

import Foundation

struct WeatherResponse: Decodable {
    let latitude: Double
    let longitude: Double
    let currentWeather: CurrentWeather

    enum CodingKeys: String, CodingKey {
        case latitude, longitude
        case currentWeather = "current_weather"
    }

    struct CurrentWeather: Decodable {
        let temperature: Double
        let windspeed: Double
        let winddirection: Double
        let weathercode: Int
        let isDay: Int
        let time: String

        enum CodingKeys: String, CodingKey {
            case temperature
            case windspeed
            case winddirection
            case weathercode
            case isDay = "is_day"
            case time
        }
    }
}
