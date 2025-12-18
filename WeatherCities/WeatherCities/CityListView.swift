//
//  CityListView.swift
//  WeatherCities
//
//  Created by Assistant on 17.12.2025.
//

import SwiftUI

// Основной список городов
struct CityListView: View {
    @State private var viewModel = WeatherViewModel()

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Weather Cities")
        }
        .task {
            await viewModel.loadWeather()
        }
        .refreshable {
            await viewModel.refresh()
        }
    }

    @ViewBuilder private var content: some View {
        switch viewModel.state {
        case .loading:
            ProgressView("Loading...")
                .progressViewStyle(.circular)
        case .error(let message):
            VStack(spacing: 12) {
                Text("Failed to load")
                    .font(.headline)
                Text(message)
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                Button("Retry") {
                    Task {
                        await viewModel.loadWeather()
                    }
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        case .content:
            VStack {
                searchAndSortControls
                List(viewModel.visibleCityWeather) { item in
                    CityRowView(item: item)
                }
                .listStyle(.plain)
            }
            .padding(.horizontal)
            .transition(.opacity)
        }
    }

    private var searchAndSortControls: some View {
        VStack(spacing: 8) {
            TextField("Search city", text: $viewModel.searchText)
                .textFieldStyle(.roundedBorder)

            HStack {
                Text("Sort by temperature")
                    .font(.subheadline)
                Spacer()
                Button {
                    viewModel.sortByTemperatureAscending.toggle()
                } label: {
                    Image(systemName: viewModel.sortByTemperatureAscending ? "arrow.up" : "arrow.down")
                }
            }
        }
    }
}
