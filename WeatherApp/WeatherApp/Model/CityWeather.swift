//
//  CityWeather.swift
//  WeatherApp
//
//  Created by Ляйсан
//

import Foundation

struct CityWeather: Identifiable {
    let id: String
    let city: City
    let weather: CurrentWeather
    
    init(id: String = UUID().uuidString, city: City, weather: CurrentWeather) {
        self.id = id
        self.city = city
        self.weather = weather
    }
}
