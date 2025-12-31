//
//  WeatherViewModel.swift
//  Weather Cities
//
//  Created by Azamat Zakirov on 30.12.2025.
//

import Foundation
import Observation

enum LoadingState {
    case idle
    case loading
    case loaded
    case error(String)
}

@Observable
class WeatherViewModel {
    var cityWeather: [CityWeather] = []
    var state: LoadingState = .idle
    var searchText: String = ""
    var sortByTemperature: Bool = false
    
    private let weatherService = WeatherService()
    private let cities = City.defaultCities
    
    var filteredAndSortedCities: [CityWeather] {
        var result = cityWeather
        
        if !searchText.isEmpty {
            result = result.filter { cityWeather in
                cityWeather.city.name.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        if sortByTemperature {
            result = result.sorted { $0.temperature > $1.temperature }
        }
        
        return result
    }
    
    func loadWeather() async {
        state = .loading
        
        do {
            cityWeather = try await weatherService.fetchWeatherForCities(cities)
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
