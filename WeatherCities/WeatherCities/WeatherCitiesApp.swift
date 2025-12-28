//
//  WeatherCitiesApp.swift
//  WeatherCities
//
//  Created by Artur Bagautdinov on 28.12.2025.
//

import SwiftUI

@main
struct WeatherListApp: App {
    var body: some Scene {
        WindowGroup {
            WeatherListView(
                viewModel: WeatherViewModel(service: RealWeatherService())
            )
        }
    }
}
