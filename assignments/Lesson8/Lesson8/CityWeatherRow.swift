//
//  CityWeatherRow.swift
//  Lesson8
//
//  Created by Timur Minkhatov on 26.12.2025.
//

import SwiftUI

struct CityWeatherRow: View {
    let weather: CityWeather
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(weather.city.name)
                    .font(.headline)
                
                Text(weatherDescription)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(weather.temperature, specifier: "%.1f")°C")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(temperatureColor)
                
                HStack(spacing: 4) {
                    Image(systemName: "wind")
                        .font(.caption)
                    Text("\(weather.windSpeed, specifier: "%.1f") km/h")
                        .font(.caption)
                }
                .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 8)
    }
    
    private var weatherDescription: String {
        switch weather.weatherCode {
        case 0:
            return "Clear sky"
        case 1, 2, 3:
            return "Partly cloudy"
        case 45, 48:
            return "Foggy"
        case 51, 53, 55:
            return "Drizzle"
        case 61, 63, 65:
            return "Rain"
        case 71, 73, 75:
            return "Snow"
        case 80, 81, 82:
            return "Rain showers"
        case 95, 96, 99:
            return "Thunderstorm"
        default:
            return "Unknown"
        }
    }
    
    private var temperatureColor: Color {
        if weather.temperature > 25 {
            return .red
        } else if weather.temperature > 15 {
            return .orange
        } else {
            return .blue
        }
    }
}
