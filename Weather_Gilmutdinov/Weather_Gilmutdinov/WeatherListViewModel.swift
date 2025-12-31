import Foundation
import Observation

enum TemperatureSortMode: String, CaseIterable, Identifiable {
    case none
    case ascending
    case descending
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .none:       return "Без сорт."
        case .ascending:  return "По возр."
        case .descending: return "По убыв."
        }
    }
}

@MainActor
@Observable
final class WeatherListViewModel {

    private let predefinedCities: [City] = [
        City(name: "Москва",            latitude: 55.7558, longitude: 37.6173),
        City(name: "Санкт-Петербург",   latitude: 59.9343, longitude: 30.3351),
        City(name: "Лондон",            latitude: 51.5074, longitude: -0.1278),
        City(name: "Нью-Йорк",          latitude: 40.7128, longitude: -74.0060),
        City(name: "Токио",             latitude: 35.6762, longitude: 139.6503),
        City(name: "Берлин",            latitude: 52.5200, longitude: 13.4050)
    ]
    
    private let api: WeatherAPI
    private var loadedItems: [CityWeather] = []
    var visibleItems: [CityWeather] {
        applyFilters(to: loadedItems)
    }
    
    var isLoading: Bool = false
    
    var errorMessage: String? = nil
    
    var searchQuery: String = ""
    
    var sortMode: TemperatureSortMode = .none
    
    init(api: WeatherAPI) {
        self.api = api
    }
    
    func load() async {
        if isLoading { return }
        
        isLoading = true
        errorMessage = nil
        loadedItems = []
        
        do {
            var tempResults: [CityWeather] = []
            try await withThrowingTaskGroup(of: CityWeather.self) { group in
                for city in predefinedCities {
                    group.addTask {
                        try await self.api.loadWeather(for: city)
                    }
                }
                for try await item in group {
                    tempResults.append(item)
                }
            }
            
            self.loadedItems = tempResults
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func retry() async {
        await load()
    }
    
    private func applyFilters(to source: [CityWeather]) -> [CityWeather] {
        var result = source
        
        let trimmedQuery = searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedQuery.isEmpty {
            result = result.filter { item in
                item.city.name.localizedCaseInsensitiveContains(trimmedQuery)
            }
        }
        
        switch sortMode {
        case .none:
            break
        case .ascending:
            result.sort { $0.temperature < $1.temperature }
        case .descending:
            result.sort { $0.temperature > $1.temperature }
        }
        
        return result
    }
}
