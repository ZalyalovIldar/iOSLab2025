//
//  WeatherService.swift
//  WeatherCities
//
//  Created by Artur Bagautdinov on 28.12.2025.
//

import Foundation

protocol WeatherService {
    func fetchWeather(for city: City) async throws -> CityWeather
}

final class RealWeatherService: WeatherService {

    private let session: URLSession
    private let decoder = JSONDecoder()

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchWeather(for city: City) async throws -> CityWeather {

        let urlString =
        "https://api.open-meteo.com/v1/forecast" +
        "?latitude=\(city.latitude)" +
        "&longitude=\(city.longitude)" +
        "&current_weather=true" +
        "&timezone=auto"

        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }

        let (data, response) = try await session.data(for: URLRequest(url: url))

        guard let http = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard (200..<300).contains(http.statusCode) else {
            throw NetworkError.badStatusCode(http.statusCode)
        }

        let decoded = try decoder.decode(WeatherResponse.self, from: data)
        let current = decoded.currentWeather

        return CityWeather(
            city: city,
            temperatureC: current.temperature,
            windSpeedKmh: current.windspeed,
            windDirectionDeg: current.winddirection,
            weatherCode: current.weathercode,
            observationTime: current.time
        )
    }
}
