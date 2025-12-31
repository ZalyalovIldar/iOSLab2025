import Foundation

protocol WeatherAPI {
    func loadWeather(for city: City) async throws -> CityWeather
}

struct DefaultWeatherAPI: WeatherAPI {
    
    func loadWeather(for city: City) async throws -> CityWeather {
        var components = URLComponents(string: "https://api.open-meteo.com/v1/forecast")!
        components.queryItems = [
            URLQueryItem(name: "latitude", value: String(city.latitude)),
            URLQueryItem(name: "longitude", value: String(city.longitude)),
            URLQueryItem(name: "current_weather", value: "true")
        ]
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        if let httpResponse = response as? HTTPURLResponse,
           httpResponse.statusCode != 200 {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        let payload = try decoder.decode(WeatherPayload.self, from: data)
        
        let current = payload.current
        
        return CityWeather(
            city: city,
            temperature: current.temperature,
            windSpeed: current.windspeed,
            windDirection: current.winddirection
        )
    }
}
