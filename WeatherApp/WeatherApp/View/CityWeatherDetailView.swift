//
//  CityWeatherDetailView.swift
//  WeatherApp
//
//  Created by Ляйсан
//

import SwiftUI

struct CityWeatherDetailView: View {
    let cityWeahter: CityWeather
    
    var body: some View {
        VStack(spacing: -3) {
            Text(cityWeahter.city.name)
                .font(.largeTitle)
                .fontWeight(.medium)
            
            HStack(spacing: 0.5) {
                if (Int(cityWeahter.weather.temperature2m.rounded())) >= 0 {
                    Text("-").opacity(0)
                }
                Text("\(Int(cityWeahter.weather.temperature2m.rounded()))")
                Text("°")
            }
            .font(.system(size: 85, weight: .light))

            Text(cityWeahter.weather.weatherDescription)
                .font(.headline)
                .foregroundStyle(.lightText)
        }
        .foregroundStyle(.white)
    }
}

#Preview {
    CityWeatherDetailView(cityWeahter: CityWeather(city: City(name: "Kazan", latitude: 0, longitude: 0), weather: CurrentWeather(temperature2m: 0.4, weatherCode: 3)))
}
