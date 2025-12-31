import Foundation

struct City: Identifiable {
    let id = UUID()
    let name: String
    let latitude: Double
    let longitude: Double
}

struct WeatherPayload: Codable {
    
    struct Current: Codable {
        let temperature: Double
        let windspeed: Double
        let winddirection: Double
        let time: String
    }
    
    let current: Current
    
    enum CodingKeys: String, CodingKey {
        case current = "current_weather"
    }
}

struct CityWeather: Identifiable {
    let id = UUID()
    let city: City
    let temperature: Double
    let windSpeed: Double
    let windDirection: Double
}
