//
//  Models.swift
//  WeatherCities
//
//  Created by Assistant on 17.12.2025.
//

import Foundation

//Город с координатами
struct City: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let latitude: Double
    let longitude: Double
}

/// json ответ от API  open-meteo
struct WeatherResponse: Decodable {
    struct CurrentWeather: Decodable {
        let temperature: Double
        let windspeed: Double
    }

    let currentWeather: CurrentWeather

    enum CodingKeys: String, CodingKey {
        case currentWeather = "current_weather"
    }
}

/// Погода для конкретного города
struct CityWeather: Identifiable {
    let id = UUID()
    let city: City
    let temperature: Double
    let windSpeed: Double
}
