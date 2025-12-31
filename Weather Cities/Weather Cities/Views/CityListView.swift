//
//  CityListView.swift
//  Weather Cities
//
//  Created by Azamat Zakirov on 30.12.2025.
//

import SwiftUI

struct CityListView: View {
    let cities: [CityWeather]
    
    var body: some View {
        if cities.isEmpty {
            ContentUnavailableView(
                "No cities found",
                systemImage: "magnifyingglass",
                description: Text("Try adjusting your search")
            )
        } else {
            List {
                ForEach(Array(cities.enumerated()), id: \.element.id) { index, cityWeather in
                    CityRowView(cityWeather: cityWeather)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
                        .transition(.move(edge: .leading).combined(with: .opacity))
                }
            }
            .listStyle(.plain)
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: cities.map { $0.id })
        }
    }
}

#Preview {
    CityListView(cities: [
        CityWeather(
            city: City(name: "Moscow", latitude: 55.7558, longitude: 37.6173),
            temperature: 22.5,
            feelsLike: 24.0,
            humidity: 65,
            windSpeed: 3.2,
            windDirection: 180,
            description: "clear sky",
            icon: "01d"
        ),
        CityWeather(
            city: City(name: "London", latitude: 51.5074, longitude: -0.1278),
            temperature: 15.3,
            feelsLike: 14.8,
            humidity: 72,
            windSpeed: 4.1,
            windDirection: 240,
            description: "cloudy",
            icon: "03d"
        )
    ])
}
