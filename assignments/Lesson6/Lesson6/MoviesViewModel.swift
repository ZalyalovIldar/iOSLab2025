//
//  Moviesviewmodel.swift
//  Lesson6
//
//  Created by Timur Minkhatov on 21.12.2025.
//

import Foundation
import SwiftUI

@Observable
final class MoviesViewModel {
    
    enum SortOption: String, CaseIterable {
        case title = "Title"
        case year = "Year"
        
        var displayName: String { rawValue }
    }
    
    var movies: [Movie] = []
    var searchText: String = ""
    var sortOption: SortOption = .title
    var navigationPath = NavigationPath()
    
    private let userDefaultsKey = "SavedMovies"
    
    var filteredAndSortedMovies: [Movie] {
        var result = movies
        
        if !searchText.isEmpty {
            result = result.filter { movie in
                movie.title.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        switch sortOption {
        case .title:
            result.sort { $0.title.localizedCompare($1.title) == .orderedAscending }
        case .year:
            result.sort { $0.releaseYear > $1.releaseYear }
        }
        
        return result
    }
    
    init() {
        loadMovies()
    }
    
    func addMovie(_ movie: Movie) {
        movies.append(movie)
        saveMovies()
    }
    
    func updateMovie(_ movie: Movie) {
        if let index = movies.firstIndex(where: { $0.id == movie.id }) {
            movies[index] = movie
            saveMovies()
        }
    }
    
    func deleteMovie(_ movie: Movie) {
        movies.removeAll { $0.id == movie.id }
        saveMovies()
    }
    
    func deleteMovies(at offsets: IndexSet) {
        let moviesToDelete = offsets.map { filteredAndSortedMovies[$0] }
        for movie in moviesToDelete {
            deleteMovie(movie)
        }
    }
    
    func saveMovies() {
        if let encoded = try? JSONEncoder().encode(movies) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }
    
    private func loadMovies() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decoded = try? JSONDecoder().decode([Movie].self, from: data) {
            movies = decoded
        } else {
            movies = Movie.samples
            saveMovies()
        }
    }
}
