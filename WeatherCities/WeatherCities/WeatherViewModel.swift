//
//  WeatherViewModel.swift
//  WeatherCities
//
//  Created by Artur Bagautdinov on 28.12.2025.
//

import SwiftUI

import Foundation

@Observable
final class WeatherViewModel {

    enum State: Equatable {
        case loading
        case empty
        case content
        case error(String)
    }

    var state: State = .loading
    var cityWeather: [CityWeather] = []

    var searchText: String = ""
    var sortOption: SortOption = .none

    private let service: WeatherService
    private let cities: [City]

    init(
        cities: [City] = City.sample,
        service: WeatherService
    ) {
        self.cities = cities
        self.service = service
    }

    func load(forceReload: Bool = false) async {
        state = .loading
        cityWeather = []

        do {
            let result = try await fetchAllWeathersParallel(for: cities)
            cityWeather = result
            state = result.isEmpty ? .empty : .content
        } catch NetworkError.decodingFailed {
            state = .error("Failed to decode data")
        } catch let NetworkError.badStatusCode(code) {
            state = .error("Bad status code: \(code)")
        } catch NetworkError.invalidURL {
            state = .error("Invalid API URL")
        } catch {
            state = .error("Unexpected error")
        }
    }

    private func fetchAllWeathersParallel(for cities: [City]) async throws -> [CityWeather] {
        try await withThrowingTaskGroup(of: CityWeather.self) { group in

            for city in cities {
                group.addTask {
                    try await self.service.fetchWeather(for: city)
                }
            }

            var collected: [CityWeather] = []
            collected.reserveCapacity(cities.count)

            for try await item in group {
                collected.append(item)
            }

            return collected
        }
    }

    enum SortOption: String, CaseIterable, Identifiable {
        case none
        case temperatureDesc
        case temperatureAsc
        case nameAsc
        case nameDesc
        case windDesc
        case windAsc

        var id: String { rawValue }

        var title: String {
            switch self {
            case .none: return "No sorting"
            case .temperatureDesc: return "Temp: High → Low"
            case .temperatureAsc: return "Temp: Low → High"
            case .nameAsc: return "Name A–Z"
            case .nameDesc: return "Name Z–A"
            case .windDesc: return "Wind: High → Low"
            case .windAsc: return "Wind: Low → High"
            }
        }
    }

    var filteredAndSorted: [CityWeather] {
        let filtered: [CityWeather]
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            filtered = cityWeather
        } else {
            filtered = cityWeather.filter {
                $0.city.name.localizedCaseInsensitiveContains(searchText)
            }
        }

        switch sortOption {
        case .none:
            return filtered
        case .temperatureAsc:
            return filtered.sorted { $0.temperatureC < $1.temperatureC }
        case .temperatureDesc:
            return filtered.sorted { $0.temperatureC > $1.temperatureC }
        case .windAsc:
            return filtered.sorted { $0.windSpeedKmh < $1.windSpeedKmh }
        case .windDesc:
            return filtered.sorted { $0.windSpeedKmh > $1.windSpeedKmh }
        case .nameAsc:
            return filtered.sorted { $0.city.name.localizedCaseInsensitiveCompare($1.city.name) == .orderedAscending }
        case .nameDesc:
            return filtered.sorted { $0.city.name.localizedCaseInsensitiveCompare($1.city.name) == .orderedDescending }
        }
    }
}
