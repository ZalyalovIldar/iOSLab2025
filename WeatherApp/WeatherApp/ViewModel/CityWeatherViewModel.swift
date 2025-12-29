//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Ляйсан
//

import Foundation

@Observable
final class CityWeatherViewModel {
    let cityWeatherService: DefaultCityWeatherService
    
    var cityWeather: [CityWeather] = []
    var isLoading = false
    var isSortedByHighest = false
    var searchText = ""
    
    var alert: AlertItem?
    var selectedCityWeather: CityWeather?
    
    private var fetchTask: Task<Void, Never>?
    
    var filteredCityWeather: [CityWeather] {
        var result = cityWeather
        
        if !searchText.isEmpty {
            result = result.filter { $0.weather.temperature2m.description.localizedCaseInsensitiveContains(searchText) ||
                $0.city.name.description.localizedCaseInsensitiveContains(searchText) }
        }
        if isSortedByHighest {
            result = result.sorted { $0.weather.temperature2m > $1.weather.temperature2m }
        }
        
        return result
    }
    
    init(cityWeatherService: DefaultCityWeatherService) {
        self.cityWeatherService = cityWeatherService
        
        getWeather()
    }
    
    func getWeather() {
        fetchTask?.cancel()
        fetchTask = Task {
            do {
                isLoading = true
                
                let cityWeather = try await cityWeatherService.fetchWeatherForAllCities()
                
                self.cityWeather = cityWeather.sorted { $0.weather.temperature2m < $1.weather.temperature2m }
                if selectedCityWeather == nil, let firstElement = cityWeather.first {
                    self.selectedCityWeather = firstElement
                }
                isLoading = false
            } catch {
                setAlert(from: error)
            }
        }
    }
    
    deinit {
        fetchTask?.cancel()
    }
    
    private func setAlert(from error: Error) {
        if let error = error as? APIError {
            switch error {
            case .invalidURL: alert = AlertContext.invalidURL
            case .invalidData: alert = AlertContext.invalidData
            case .invalidResponse: alert = AlertContext.invalidResponse
            case .badStatusCode(let statusCode): alert = AlertContext.badStatusCode(statusCode)
            }
        } else {
            alert = AlertItem(title: "Server Error", message: error.localizedDescription)
        }
    }
}
