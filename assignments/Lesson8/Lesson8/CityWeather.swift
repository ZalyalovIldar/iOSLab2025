//
//  CityWeather.swift
//  Lesson8
//
//  Created by Timur Minkhatov on 26.12.2025.
//

import Foundation

struct CityWeather: Identifiable {
    let id: UUID
    let city: City
    let temperature: Double
    let windSpeed: Double
    let weatherCode: Int
    
    init(city: City, temperature: Double, windSpeed: Double, weatherCode: Int) {
        self.id = city.id
        self.city = city
        self.temperature = temperature
        self.windSpeed = windSpeed
        self.weatherCode = weatherCode
    }
    
    var temperatureColor: String {
        if temperature > 25 {
            return "red"
        } else if temperature > 15 {
            return "orange"
        } else {
            return "blue"
        }
    }
}
