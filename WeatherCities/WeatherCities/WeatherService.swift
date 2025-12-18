//
//  WeatherService.swift
//  WeatherCities
//
//  Created by Assistant on 17.12.2025.
//

import Foundation

/// Сервис загрузки погоды
struct WeatherService {

    enum ServiceError: Error {
        case invalidURL //не удалось сформулировать url
        case invalidResponse //неправильный ответ от сервера
    }

    // Загружает погоду для одного города
    func fetchWeather(for city: City) async throws -> CityWeather { //асинхронная функция принимающая обьект города
        //возвращаем тип который содержит инфо о городе и о погоде
        guard let url = makeURL(for: city) else { //формируем url
            throw ServiceError.invalidURL //ошибка создания url
        }

        // Простой retry до 3 попыток
        var lastError: Error? //сохраняем последнюю ошибку из всех попыток

        for _ in 0..<3 { //3 попытки
            do {
                let (data, response) = try await URLSession.shared.data(from: url) //данные и ответ сервера

                guard
                    let httpResponse = response as? HTTPURLResponse,// преобразуем response в HTTPURLResponse - тип для http ответов
                    (200..<300).contains(httpResponse.statusCode) //проверяем статус код чтобы был успех
                else {
                    throw ServiceError.invalidResponse //если ошибка
                }

                let decoder = JSONDecoder()
                let weatherResponse = try decoder.decode(WeatherResponse.self, from: data)  //`преобразуем data в WeatherResponse.self
                let current = weatherResponse.currentWeather //присваем текущую погоду

                return CityWeather(
                    city: city,
                    temperature: current.temperature,
                    windSpeed: current.windspeed
                ) //возвращаем инфо о городе и его погоде
            } catch {
                lastError = error //сохраняем ошибку, если попытки не выполнились то выбрасываем ошибку
                // небольшая задержка между попытками
                try? await Task.sleep(nanoseconds: 300_000_000)
            }
        }

        throw lastError ?? ServiceError.invalidResponse //если не nil то выбрасываем ошибку
    }

    private func makeURL(for city: City) -> URL? { //метод для создания url к api, возвр url или nil
        var components = URLComponents() //объект для построения URL по частям
        components.scheme = "https" //протокол
        components.host = "api.open-meteo.com" //адрес сервера
        components.path = "/v1/forecast" //путь на сервере
        //параметр запроса
        components.queryItems = [
            URLQueryItem(name: "latitude", value: String(city.latitude)),
            URLQueryItem(name: "longitude", value: String(city.longitude)),
            URLQueryItem(name: "current_weather", value: "true")
        ]
        return components.url //возвращаем готоовый url
    }
}
