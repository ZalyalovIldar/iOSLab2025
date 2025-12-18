//
//  WeatherViewModel.swift
//  WeatherCities
//
//  Created by Assistant on 17.12.2025.
//

import Foundation
import SwiftUI
import Observation

enum WeatherViewState { //возможные состояния экрана
    case loading
    case content
    case error(String)
}

@Observable //наблюдаемый класс
class WeatherViewModel {

    var cityWeather: [CityWeather] = [] //массив погоды всех городов
    var state: WeatherViewState = .loading //текушее состояние

    // поиск и сортировка
    var searchText: String = ""
    var sortByTemperatureAscending: Bool = true


    private let service = WeatherService() //создаем сервис

    // Набор городов для загрузки
    private let cities: [City] = [
        City(name: "Moscow", latitude: 55.7558, longitude: 37.6176),
        City(name: "Saint Petersburg", latitude: 59.9311, longitude: 30.3609),
        City(name: "London", latitude: 51.5074, longitude: -0.1278),
        City(name: "New York", latitude: 40.7128, longitude: -74.0060),
        City(name: "Tokyo", latitude: 35.6764, longitude: 139.6500),
        City(name: "Dubai", latitude: 25.2048, longitude: 55.2708)
    ]

    
    // Отфильтрованный и отсортированный массив для отображения
    var visibleCityWeather: [CityWeather] {
        var items = cityWeather //копируем массив

        if !searchText.isEmpty {
            items = items.filter { $0.city.name.lowercased().contains(searchText.lowercased()) }  //сортируем только для которых true
        }

        items.sort { first, second in
            if sortByTemperatureAscending {
                return first.temperature < second.temperature //по возрастанию
            } else {
                return first.temperature > second.temperature //по убыванию
            }
        }

        return items //возврашаем отфильтрованный и отсортированный массив
    }

    // Основная загрузка
    @MainActor //главный поток
    func loadWeather() async { //асинхронная ыункция
        state = .loading //загрузка

        do {
            let result = try await fetchAllCitiesWeather() //загружаем данные
            withAnimation { //с анимацией
                self.cityWeather = result //сохраняем загруженные данные
                self.state = .content //показываем контент
            }
        } catch {
            self.state = .error(error.localizedDescription) //экран ошибки с кнопкой rеtry
        }
    }

    // обновление данных
    @MainActor
    func refresh() async { //при потягивании вниз экрана
        do {
            let result = try await fetchAllCitiesWeather()
            withAnimation {
                self.cityWeather = result
                self.state = .content
            }
        } catch {
            self.state = .error(error.localizedDescription)
        }
    }

    //параллельная загрузка погоды
    private func fetchAllCitiesWeather() async throws -> [CityWeather] {
        var result: [CityWeather] = [] //массив результатов

        try await withThrowingTaskGroup(of: CityWeather.self) { group in //создаем группу задач каждая задача вернет CityWeather
            for city in cities {
                group.addTask { //добавляем задачу в группу
                    try await self.service.fetchWeather(for: city) //каждая задача загружает погоду для одного города
                }
            }

            for try await cityWeather in group { //собираем результат
                result.append(cityWeather) //добавляем в массив
            }
        }

        return result
    }
}
