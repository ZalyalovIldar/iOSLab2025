//
//  WeatherViewModel.swift
//  Lesson8
//
//  Created by Timur Minkhatov on 26.12.2025.
//

import Foundation
import Observation

enum LoadingState: Equatable {
    case idle
    case loading
    case loaded
    case error(String)
}

@Observable
final class WeatherViewModel {
    private(set) var cityWeather: [CityWeather] = []
    private(set) var state: LoadingState = .idle
    var searchText: String = ""
    var sortByTemperature: Bool = false
    
    private let weatherService = WeatherService()
    
    private let cities: [City] = [
        City(name: "Moscow", latitude: 55.7558, longitude: 37.6173),
        City(name: "Barcelona", latitude: 41.3874, longitude: 2.1686),
        City(name: "Kazan", latitude: 55.7887, longitude: 49.1221),
        City(name: "Nizhnekamsk", latitude: 55.6364, longitude: 51.8209),
        City(name: "Rome", latitude: 41.9028, longitude: 12.4964),
        City(name: "Dubai", latitude: 25.2048, longitude: 55.2708),
        City(name: "Phuket", latitude: 7.8804, longitude: 98.3923)
    ]
    
    var filteredAndSortedWeather: [CityWeather] {
        var result = cityWeather
        
        if !searchText.isEmpty {
            result = result.filter { weather in
                weather.city.name.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        if sortByTemperature {
            result = result.sorted { $0.temperature > $1.temperature }
        }
        
        return result
    }
    
    func loadWeather() async {
        state = .loading
        cityWeather = []
        
        do {
            let loadedWeather = try await weatherService.fetchWeather(for: cities)
            cityWeather = loadedWeather
            state = .loaded
        } catch {
            state = .error(error.localizedDescription)
        }
    }
    
    func retry() {
        Task {
            await loadWeather()
        }
    }
}
