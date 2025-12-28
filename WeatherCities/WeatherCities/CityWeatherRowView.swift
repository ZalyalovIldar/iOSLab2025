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

                HStack(spacing: 8) {
                    Text(item.codeDescription)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(item.temperatureText)
                    .font(.headline)
                    .foregroundStyle(item.temperatureColor)
                    .monospacedDigit()
                
                HStack(spacing: 4) {
                    Text("💨 \(item.windText) \(item.compassDirection)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.blue.opacity(0.08))
                .stroke(.gray.opacity(0.35), lineWidth: 1)
        )
    }
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
