import SwiftUI
import Observation

struct RootWeatherView: View {
    
    @State private var viewModel = WeatherListViewModel(api: DefaultWeatherAPI())
    
    var body: some View {
        NavigationStack {
            WeatherListScreen(viewModel: viewModel)
                .navigationTitle("Города и погода")
        }
        .task {
            await viewModel.load()
        }
    }
}

#Preview {
    RootWeatherView()
}

struct WeatherListScreen: View {
    
    @Bindable var viewModel: WeatherListViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            controlsPanel
            
            Divider()
            
            Group {
                if viewModel.isLoading {
                    loadingView
                } else if let errorText = viewModel.errorMessage {
                    errorView(text: errorText)
                } else {
                    WeatherCitiesListView(items: viewModel.visibleItems)
                }
            }
            .animation(.default, value: viewModel.isLoading)
            .animation(.default, value: viewModel.errorMessage)
            .animation(.default, value: viewModel.visibleItems.count)
        }
    }
    
    private var controlsPanel: some View {
        VStack(spacing: 8) {
            TextField("Поиск города", text: $viewModel.searchQuery)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
            
            Picker("Сортировка", selection: $viewModel.sortMode) {
                ForEach(TemperatureSortMode.allCases) { mode in
                    Text(mode.title).tag(mode)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            .padding(.bottom, 8)
        }
        .padding(.top, 8)
    }
    
    private var loadingView: some View {
        VStack(spacing: 12) {
            ProgressView()
            Text("Загружаем данные…")
                .font(.headline)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func errorView(text: String) -> some View {
        VStack(spacing: 16) {
            Text("Что-то пошло не так")
                .font(.headline)
            Text(text)
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button {
                Task {
                    await viewModel.retry()
                }
            } label: {
                Text("Попробовать ещё раз")
                    .padding(.horizontal, 24)
                    .padding(.vertical, 8)
                    .background(.blue)
                    .foregroundStyle(.white)
                    .clipShape(Capsule())
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

struct WeatherCitiesListView: View {
    
    let items: [CityWeather]
    
    var body: some View {
        if items.isEmpty {
            VStack(spacing: 8) {
                Text("Нет подходящих городов")
                    .font(.headline)
                Text("Попробуйте изменить поиск или сортировку.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            List(items) { item in
                WeatherCityRowView(item: item)
            }
            .listStyle(.plain)
        }
    }
}

struct WeatherCityRowView: View {
    
    let item: CityWeather
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text(item.city.name)
                    .font(.headline)
                
                Text("Ветер: \(Int(item.windSpeed)) км/ч")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Text(String(format: "%.1f℃", item.temperature))
                .font(.title3.bold())
                .foregroundStyle(item.temperature > 25 ? Color.red : Color.primary)
        }
        .padding(.vertical, 6)
    }
}
