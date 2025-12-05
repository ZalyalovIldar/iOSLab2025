//
//  MoviesListView.swift
//  MovieBrowser
//
//  Created by krnklvx on 04.12.2025.
//

import SwiftUI

struct MoviesListView: View {
    @Bindable var viewModel: MoviesViewModel
    @State private var isShowingAddMovie = false
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                // Поиск
                Section {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.secondary)
                        TextField("Поиск по названию", text: $viewModel.searchText)
                    }
                }
                
                // Сортировка
                Section {
                    Picker("Сортировка", selection: $viewModel.sortOption) {
                        ForEach(SortOption.allCases, id: \.self) { option in
                            Text(option.rawValue).tag(option)
                        }
                    }
                }
                
                // Список фильмов
                Section("Фильмы") {
                    ForEach(viewModel.filteredAndSortedMovies) { movie in
                        NavigationLink(value: movie) {
                            MovieRowView(movie: movie)
                        }
                    }
                    .onDelete { offsets in
                        withAnimation(.easeInOut(duration: 0.3)) {
                            // Удаление с учетом отфильтрованного списка
                            let filteredMovies = viewModel.filteredAndSortedMovies
                            for index in offsets {
                                let movieToDelete = filteredMovies[index]
                                if let originalIndex = viewModel.movies.firstIndex(where: { $0.id == movieToDelete.id }) {
                                    viewModel.movies.remove(at: originalIndex)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Фильмы")
            .navigationDestination(for: Movie.self) { movie in
                MovieDetailView(
                    movie: binding(for: movie),
                    viewModel: viewModel
                )
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isShowingAddMovie = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isShowingAddMovie) {
                AddMovieView(viewModel: viewModel)
            }
        }
    }
    
    private func binding(for movie: Movie) -> Binding<Movie> { //функция принимает параметр movie возвращает привязку
        Binding(
            get: { viewModel.movies.first(where: { $0.id == movie.id }) ?? movie }, //возвращает актуальный фильм
            set: { viewModel.updateMovie($0) } //вызывает update и обновляет массив
        )
    }
}
