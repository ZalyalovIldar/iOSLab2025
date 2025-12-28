//
//  CityWeatherRowView.swift
//  WeatherCities
//
//  Created by Artur Bagautdinov on 28.12.2025.
//

import SwiftUI

struct CityWeatherRowView: View {

    let item: CityWeather

    var body: some View {
        
        HStack(spacing: 12) {

            Image(systemName: item.symbolName)
                .font(.system(size: 26))
                .frame(width: 36)

            VStack(alignment: .leading, spacing: 4) {
                
                Text(item.city.name)
                    .font(.headline)
            
                Text(item.codeDescription)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                
                Text(item.temperatureText)
                    .font(.headline)
                    .foregroundStyle(item.temperatureColor)
                    .monospacedDigit()
                
                Text("💨 \(item.windText) \(item.compassDirection)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(cardGradient)
                .stroke(.gray.opacity(0.35), lineWidth: 1)
                .shadow(
                    color: .black.opacity(0.12),
                    radius: 8,
                    x: 0,
                    y: 4
                )
        )
    }
}

private var cardGradient: LinearGradient {
    LinearGradient(
        colors: [
            Color(red: 1.00, green: 1.00, blue: 1.00),
            Color(red: 0.96, green: 0.99, blue: 1.00),
            Color(red: 0.92, green: 0.97, blue: 1.00)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

#Preview {
    CityWeatherRowView(item: CityWeather(
        city: City(name: "Madrid", latitude: 0, longitude: 0),
        temperatureC: 25,
        windSpeedKmh: 11,
        windDirectionDeg: 120,
        weatherCode: 95,
        observationTime: "2025-12-28T12:00"
    ))
    .padding()
}
