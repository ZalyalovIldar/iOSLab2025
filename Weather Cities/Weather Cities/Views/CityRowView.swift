//
//  CityRowView.swift
//  Weather Cities
//
//  Created by Azamat Zakirov on 30.12.2025.
//

import SwiftUI

struct CityRowView: View {
    let cityWeather: CityWeather
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text(cityWeather.city.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(cityWeather.description.capitalized)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 8) {
                    Label(cityWeather.windSpeedFormatted, systemImage: "wind")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Label("\(cityWeather.humidity)%", systemImage: "humidity")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(cityWeather.temperatureFormatted)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(cityWeather.temperature > 25 ? .red : .blue)
                
                Text("Feels like \(String(format: "%.1f°C", cityWeather.feelsLike))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
    }
}

#Preview {
    CityRowView(cityWeather: CityWeather(
        city: City(name: "Moscow", latitude: 55.7558, longitude: 37.6173),
        temperature: 22.5,
        feelsLike: 24.0,
        humidity: 65,
        windSpeed: 3.2,
        windDirection: 180,
        description: "clear sky",
        icon: "01d"
    ))
    .previewLayout(.sizeThatFits)
}
