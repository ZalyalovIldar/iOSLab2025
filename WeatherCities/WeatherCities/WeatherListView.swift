//
//  ContentView.swift
//  WeatherCities
//
//  Created by Artur Bagautdinov on 28.12.2025.
//

import SwiftUI

struct WeatherListView: View {

    @Bindable var viewModel: WeatherViewModel

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Weather")
                .searchable(text: $viewModel.searchText, prompt: "Search city")
                .task {
                    await viewModel.load()
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu {
                            Picker("Sort", selection: $viewModel.sortOption) {
                                ForEach(WeatherViewModel.SortOption.allCases) { option in
                                    Text(option.title).tag(option)
                                }
                            }
                        } label: {
                            Image(systemName: "arrow.up.arrow.down")
                        }
                    }
                }
        }
    }

    @ViewBuilder private var content: some View {
        switch viewModel.state {

        case .loading:
            ProgressView()
                .frame(maxWidth: .infinity, minHeight: 200)

        case .empty:
            EmptyStateView(
                title: "No cities",
                subtitle: "Try reloading"
            ) {
                Task { await viewModel.load() }
            }

        case .content:
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 10) {
                    ForEach(viewModel.filteredAndSorted) { item in
                        CityWeatherRowView(item: item)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical)
            }
            .refreshable {
                await viewModel.load()
            }

        case .error(let message):
            ErrorView(message: message) {
                Task { await viewModel.load() }
            }
        }
    }
}

#Preview {
    WeatherListView(viewModel: WeatherViewModel(service: RealWeatherService()))
}
