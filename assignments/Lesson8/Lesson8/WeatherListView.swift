//
//  WeatherListView.swift
//  Lesson8
//
//  Created by Timur Minkhatov on 26.12.2025.
//

import SwiftUI

struct WeatherListView: View {
    @State private var viewModel = WeatherViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                switch viewModel.state {
                case .idle, .loading:
                    VStack {
                        ProgressView()
                            .scaleEffect(1.5)
                        Text("Loading weather data")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                            .padding(.top)
                    }
                    
                case .loaded:
                    if viewModel.filteredAndSortedWeather.isEmpty {
                        ContentUnavailableView(
                            "No cities found",
                            systemImage: "magnifyingglass",
                            description: Text("Try adjusting your search")
                        )
                    } else {
                        List(viewModel.filteredAndSortedWeather) { weather in
                            CityWeatherRow(weather: weather)
                        }
                        .listStyle(.plain)
                    }
                    
                case .error(let message):
                    ContentUnavailableView {
                        Label("Error Loading Weather", systemImage: "exclamationmark.triangle")
                    } description: {
                        Text(message)
                    } actions: {
                        Button("Retry") {
                            viewModel.retry()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
            .searchable(text: $viewModel.searchText, prompt: "Search cities")
            .navigationTitle("Weather Cities")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.sortByTemperature.toggle()
                    } label: {
                        Image(systemName: viewModel.sortByTemperature ? "arrow.up.arrow.down.circle.fill" : "arrow.up.arrow.down.circle")
                    }
                    .disabled(viewModel.state != .loaded)
                }
            }
        }
        .task {
            if case .idle = viewModel.state {
                await viewModel.loadWeather()
            }
        }
    }
}
