//
//  WeatherService.swift
//  Weather Cities
//
//  Created by Azamat Zakirov on 30.12.2025.
//

import Foundation

enum WeatherServiceError: LocalizedError {
    case invalidURL
    case noData
    case decodingError
    case networkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .decodingError:
            return "Failed to decode response"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }
}

class WeatherService {
    private let apiKey = "cd8bb144da824cfd1420e96b384fc2b8"
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather"
    
    func fetchWeather(for city: City) async throws -> CityWeather {
        let urlString = "\(baseURL)?lat=\(city.latitude)&lon=\(city.longitude)&appid=\(apiKey)&units=metric"
        
        guard let url = URL(string: urlString) else {
            throw WeatherServiceError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw WeatherServiceError.networkError(NSError(domain: "HTTPError", code: 0))
            }
            
            let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
            
            return CityWeather(
                city: city,
                temperature: weatherResponse.main.temp,
                feelsLike: weatherResponse.main.feelsLike,
                humidity: weatherResponse.main.humidity,
                windSpeed: weatherResponse.wind.speed,
                windDirection: weatherResponse.wind.deg,
                description: weatherResponse.weather.first?.description ?? "",
                icon: weatherResponse.weather.first?.icon ?? ""
            )
        } catch let error as DecodingError {
            throw WeatherServiceError.decodingError
        } catch {
            throw WeatherServiceError.networkError(error)
        }
    }
    
    func fetchWeatherForCities(_ cities: [City]) async throws -> [CityWeather] {
        try await withThrowingTaskGroup(of: CityWeather.self) { group in
            for city in cities {
                group.addTask {
                    try await self.fetchWeather(for: city)
                }
            }
            
            var results: [CityWeather] = []
            for try await cityWeather in group {
                results.append(cityWeather)
            }
            
            return results
        }
    }
}
