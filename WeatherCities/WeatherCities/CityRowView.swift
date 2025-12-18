//
//  CityRowView.swift
//  WeatherCities
//
//  Created by Assistant on 17.12.2025.
//

import SwiftUI

/// Отдельная строка города
struct CityRowView: View {
    let item: CityWeather

    private var temperatureColor: Color {
        item.temperature > 25 ? .red : .primary
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.city.name)
                    .font(.headline)
                Text("Wind: \(Int(item.windSpeed)) m/s")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text("\(Int(item.temperature))°")
                .font(.title2.bold())
                .foregroundStyle(temperatureColor)
        }
        .padding(.vertical, 8)
    }
}
