//
//  CityWeatherService.swift
//  WeatherApp
//
//  Created by Ляйсан
//

import Foundation

protocol CityWeatherService {
    func fetchWeatherForAllCities() async throws -> [CityWeather]
}
