//
//  ContentView.swift
//  WeatherCities
//
//  Created by Artur Bagautdinov on 28.12.2025.
//

import SwiftUI

struct WeatherListView: View {

    @Bindable var viewModel: WeatherViewModel
    
    @State private var glowOn = false

    var body: some View {
        
        NavigationStack {
            
            ZStack {
                
                backgroundGradient
                    .ignoresSafeArea()
                
                content
                    .navigationTitle("Weather")
                    .searchable(text: $viewModel.searchText, prompt: "Search city")
                    .task {
                        await viewModel.load()
                    }
                    .onChange(of: viewModel.state) { _, newValue in
                        guard newValue == .content else { return }
                        withAnimation(.easeOut(duration: 0.3)) {
                            glowOn = true
                        }
                        withAnimation(.easeIn(duration: 0.5).delay(0.5)) {
                            glowOn = false
                        }
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
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.yellow.opacity(glowOn ? 0.25 : 0.0), lineWidth: 2)
                        .blur(radius: 10)
                )
                .shadow(
                    color: .yellow.opacity(glowOn ? 0.18 : 0.0),
                    radius: glowOn ? 24 : 0
                )
            }
            .refreshable {
                await viewModel.load()
            }
            .animation(.easeInOut(duration: 0.25), value: viewModel.state)
            .animation(.easeInOut(duration: 0.15), value: viewModel.searchText)
        
        case .error(let message):
            ErrorView(message: message) {
                Task { await viewModel.load() }
            }
        }
    }
}

private var backgroundGradient: LinearGradient {
    LinearGradient(
        colors: [
            Color(red: 0.88, green: 0.94, blue: 1.0),
            Color(red: 0.94, green: 0.97, blue: 1.0),
            Color(red: 0.90, green: 0.95, blue: 0.99)
        ],
        startPoint: .top,
        endPoint: .bottom
    )
}

#Preview {
    WeatherListView(viewModel: WeatherViewModel(service: RealWeatherService()))
}
