//
//  MoviesViewModel.swift
//  MovieBrowser
//
//  Created by krnklvx on 04.12.2025.
//

import Foundation
import Observation

enum SortOption: String, CaseIterable {
    case title = "По названию"
    case year = "По году"
    case none = "Без сортировки"
}

@Observable
final class MoviesViewModel {
    var movies: [Movie] = []
    var searchText: String = ""
    var sortOption: SortOption = .none
    
    private let moviesKey = "savedMovies"
    
    init() {
        loadMovies()
        // Загружаем дефолтные фильмы только если нет сохраненных (отключено)
    }
    
    var filteredAndSortedMovies: [Movie] {
        var result = movies
        
        // Поиск
        if !searchText.isEmpty {
            result = result.filter { movie in
                movie.title.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // Сортировка
        switch sortOption {
        case .title:
            result.sort { $0.title < $1.title }
        case .year:
            result.sort { $0.releaseYear > $1.releaseYear }
        case .none:
            break
        }
        
        return result
    }
    
    func addMovie(title: String, genre: String, description: String, releaseYear: Int, posterSymbol: String = "film.fill") {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else { return }
        
        let newMovie = Movie(
            title: trimmedTitle,
            genre: genre,
            description: description,
            releaseYear: releaseYear,
            posterSymbol: posterSymbol
        )
        
        movies.insert(newMovie, at: 0)
        saveMovies()
    }
    
    func removeMovie(at offsets: IndexSet) {
        movies.remove(atOffsets: offsets)
        saveMovies()
    }
    
    func updateMovie(_ movie: Movie) {
        if let index = movies.firstIndex(where: { $0.id == movie.id }) {
            movies[index] = movie
            saveMovies()
        }
    }
    
    // MARK: - UserDefaults
    
    private func saveMovies() {
        if let encoded = try? JSONEncoder().encode(movies) {
            UserDefaults.standard.set(encoded, forKey: moviesKey)
        }
    }
    
    private func loadMovies() {
        if let data = UserDefaults.standard.data(forKey: moviesKey),
           let decoded = try? JSONDecoder().decode([Movie].self, from: data) {
            movies = decoded
        }
    }
}
