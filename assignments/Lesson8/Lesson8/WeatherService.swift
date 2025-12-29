//
//  WeatherService.swift
//  Lesson8
//
//  Created by Timur Minkhatov on 26.12.2025.
//

import Foundation

enum WeatherError: Error {
    case invalidURL
    case networkError(Error)
    case decodingError
}

final class WeatherService {
    private let baseURL = "https://api.open-meteo.com/v1/forecast"
    
    func fetchWeather(for cities: [City]) async throws -> [CityWeather] {
        guard var components = URLComponents(string: baseURL) else {
            throw WeatherError.invalidURL
        }
        
        let latitudes = cities.map { String($0.latitude) }.joined(separator: ",")
        let longitudes = cities.map { String($0.longitude) }.joined(separator: ",")
        
        components.queryItems = [
            URLQueryItem(name: "latitude", value: latitudes),
            URLQueryItem(name: "longitude", value: longitudes),
            URLQueryItem(name: "current", value: "temperature_2m,wind_speed_10m,weather_code")
        ]
        
        guard let url = components.url else {
            throw WeatherError.invalidURL
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let jsonString = String(data: data, encoding: .utf8) ?? ""
            
            if jsonString.starts(with: "[") {
                let responses = try JSONDecoder().decode([WeatherResponse].self, from: data)
                
                return zip(cities, responses).map { city, response in
                    CityWeather(
                        city: city,
                        temperature: response.current.temperature2m,
                        windSpeed: response.current.windSpeed10m,
                        weatherCode: response.current.weatherCode
                    )
                }
            } else {
                let response = try JSONDecoder().decode(WeatherResponse.self, from: data)
                guard let city = cities.first else {
                    throw WeatherError.decodingError
                }
                return [CityWeather(
                    city: city,
                    temperature: response.current.temperature2m,
                    windSpeed: response.current.windSpeed10m,
                    weatherCode: response.current.weatherCode
                )]
            }
        } catch is DecodingError {
            throw WeatherError.decodingError
        } catch {
            throw WeatherError.networkError(error)
        }
    }
}
