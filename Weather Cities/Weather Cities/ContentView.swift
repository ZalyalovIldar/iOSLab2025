//
//  ContentView.swift
//  Weather Cities
//
//  Created by Azamat Zakirov on 30.12.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel = WeatherViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                switch viewModel.state {
                case .idle, .loading:
                    ProgressView("Loading weather...")
                        .scaleEffect(1.5)
                    
                case .loaded:
                    VStack(spacing: 0) {
                        VStack(spacing: 12) {
                            SearchBar(text: $viewModel.searchText)
                            
                            HStack {
                                Button(action: {
                                    withAnimation(.spring(response: 0.3)) {
                                        viewModel.sortByTemperature.toggle()
                                    }
                                }) {
                                    HStack {
                                        Image(systemName: viewModel.sortByTemperature ? "arrow.up.arrow.down.circle.fill" : "arrow.up.arrow.down.circle")
                                        Text(viewModel.sortByTemperature ? "Sorted by Temperature" : "Sort by Temperature")
                                    }
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                                }
                                
                                Spacer()
                            }
                            .padding(.horizontal, 16)
                        }
                        .padding(.vertical, 8)
                        
                        CityListView(cities: viewModel.filteredAndSortedCities)
                            .refreshable {
                                await viewModel.loadWeather()
                            }
                    }
                    
                case .error(let message):
                    VStack(spacing: 20) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 50))
                            .foregroundColor(.orange)
                        
                        Text("Error")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text(message)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        Button(action: {
                            viewModel.retry()
                        }) {
                            HStack {
                                Image(systemName: "arrow.clockwise")
                                Text("Retry")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(Color.blue)
                            .cornerRadius(10)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Weather Cities")
            .task {
                if case .idle = viewModel.state {
                    await viewModel.loadWeather()
                }
            }
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField("Search cities...", text: $text)
                .textFieldStyle(.plain)
            
            if !text.isEmpty {
                Button(action: {
                    withAnimation {
                        text = ""
                    }
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(.regularMaterial)
        .cornerRadius(10)
        .padding(.horizontal, 16)
    }
}

#Preview {
    ContentView()
}
