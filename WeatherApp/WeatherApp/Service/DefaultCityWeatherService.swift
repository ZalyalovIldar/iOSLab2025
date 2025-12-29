//
//  DefaultCityWeatherService.swift
//  WeatherApp
//
//  Created by Ляйсан
//

import Foundation

final class DefaultCityWeatherService: CityWeatherService {
    let networkService: NetworkService

    private lazy var decoder = JSONDecoder()
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func fetchWeatherForAllCities() async throws -> [CityWeather] {
        try await withThrowingTaskGroup(of: (City, Data).self) { group in
            var result: [CityWeather] = []
            
            for city in City.cities {
                group.addTask {
                    let data = try await self.networkService.fetchData(from: "https://api.open-meteo.com/v1/forecast?latitude=\(city.latitude)&longitude=\(city.longitude)&current=temperature_2m,weather_code")
                    return (city, data)
                }
            }
            
            for try await response in group {
                do {
                    let (city, data) = response 
                    let weather = try decoder.decode(WeatherResponse.self, from: data)
                    
                    let cityWeather = CityWeather(city: city, weather: weather.current)
                    result.append(cityWeather)
                } catch {
                    throw error
                }
            }
            return result
        }
    }
}
