//
//  CityWeatherView.swift
//  WeatherApp
//
//  Created by Ляйсан
//

import SwiftUI

struct CityWeatherView: View {
    @Bindable var cityWeatherViewModel: CityWeatherViewModel
    
    var body: some View {
        ZStack {
            StarSkyView()
            VStack {
                if cityWeatherViewModel.isLoading || cityWeatherViewModel.selectedCityWeather == nil {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    weatherDetailView
                    VStack {
                        listHeader
                        cityWeatherList
                            .refreshable {
                                cityWeatherViewModel.getWeather()
                            }
                    }
                    .padding(.vertical)
                    .background {
                        WeatherListBackground(colors: Color.darkListBackgroundColors)
                    }
                    .padding(.horizontal)
                    .padding(.top, 75)
                }
            }
            .alert(cityWeatherViewModel.alert?.title ?? "", isPresented: bindingAlert) {
                retryButton
            } message: {
                Text(cityWeatherViewModel.alert?.message ?? "")
            }
        }
        .searchable(text: $cityWeatherViewModel.searchText, placement: .toolbar, prompt: "Search for a city")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                contextMenu
            }
        }
    }
    
    @ViewBuilder private var weatherDetailView: some View {
        if let currentCity = cityWeatherViewModel.selectedCityWeather {
            CityWeatherDetailView(cityWeahter: currentCity)
                .frame(maxWidth: .infinity)
        }
    }
    
    @ViewBuilder private var listHeader: some View {
        HStack {
            Image(systemName: "thermometer.variable")
            Text("Top 20 cities".uppercased())
        }
        .font(.subheadline)
        .foregroundStyle(.lightText)
        .padding(.horizontal)
        .frame(maxWidth: .infinity, alignment: .leading)
        RowsDivider()
    }
    
    private var cityWeatherList: some View {
        ScrollView {
            ForEach(cityWeatherViewModel.filteredCityWeather) { cityWeather in
                CityWeatherRowView(cityWeahter: cityWeather)
                    .onTapGesture {
                        cityWeatherViewModel.selectedCityWeather = cityWeather
                    }
                RowsDivider()
             }
        }
        .scrollIndicators(.hidden)
    }
    
    private var bindingAlert: Binding<Bool> {
        Binding {
            cityWeatherViewModel.alert != nil
        } set: { newValue in
            if !newValue {
                cityWeatherViewModel.alert = nil
            }
        }
    }
    
    private var retryButton: some View {
        Button("Retry") {
            cityWeatherViewModel.getWeather()
        }
    }
    
    private var contextMenu: some View {
        Menu {
            Menu {
                SortButton(image: cityWeatherViewModel.isSortedByHighest ? "checkmark" : " ", text: "Highest First") {
                    cityWeatherViewModel.isSortedByHighest = true
                }
                SortButton(image: !cityWeatherViewModel.isSortedByHighest ? "checkmark" : " ", text: "Lowest First") {
                    cityWeatherViewModel.isSortedByHighest = false
                }
            } label: {
                HStack {
                    Image(systemName: "arrow.up.arrow.down")
                    Text("Sort by")
                }
            }
        } label: {
            Image(systemName: "line.3.horizontal.decrease")
        }
    }
}

#Preview {
    NavigationStack {
        CityWeatherView(cityWeatherViewModel: CityWeatherViewModel(cityWeatherService: DefaultCityWeatherService(networkService: DefaultNetworkService())))
    }
}
