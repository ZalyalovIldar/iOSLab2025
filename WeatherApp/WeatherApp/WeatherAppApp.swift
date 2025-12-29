//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by Ляйсан
//

import SwiftUI

@main
struct WeatherAppApp: App {
    @State var cityWeatherViewModel: CityWeatherViewModel
    let cityweatherService = DefaultCityWeatherService(networkService: DefaultNetworkService())
    
    init() {
        self._cityWeatherViewModel = .init(initialValue: CityWeatherViewModel(cityWeatherService: cityweatherService))
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                CityWeatherView(cityWeatherViewModel: cityWeatherViewModel)
            }
            .colorScheme(.dark)
        }
    }
}
