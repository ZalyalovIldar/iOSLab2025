//
//  MovieViewModel.swift
//  MovieBrowser
//
//  Created by Artur Bagautdinov on 17.12.2025.
//

import SwiftUI

@Observable
final class MoviesViewModel {
    
    enum SortOption: Hashable {
        case none
        case title
        case year
    }
    
    private let storageKey = "movies_storage"
    
    var movies: [Movie] = [] {
        didSet { save() }
    }
    
    var searchText: String = ""
    var sortOption: SortOption = .none
    
    var lastAddedMovieID: UUID?
    
    init() {
        load()
    }
    
    var filteredMovies: [Movie] {
        var result = movies
        
        if !searchText.isEmpty {
            result = result.filter {
                $0.title.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        switch sortOption {
        case .none:
            return result
        case .title:
            return result.sorted { lhs, rhs in
                let cmp = lhs.title.localizedCaseInsensitiveCompare(rhs.title)
                if cmp == .orderedSame {
                    if lhs.releaseYear == rhs.releaseYear {
                        return lhs.id.uuidString < rhs.id.uuidString
                    } else {
                        return lhs.releaseYear < rhs.releaseYear
                    }
                }
                return cmp == .orderedAscending
            }
        case .year:
            return result.sorted { lhs, rhs in
                if lhs.releaseYear == rhs.releaseYear {
                    let cmp = lhs.title.localizedCaseInsensitiveCompare(rhs.title)
                    if cmp == .orderedSame {
                        return lhs.id.uuidString < rhs.id.uuidString
                    }
                    return cmp == .orderedAscending
                }
                return lhs.releaseYear < rhs.releaseYear
            }
        }
    }
    
    func add(movie: Movie) {
        withAnimation(.spring(response: 0.45, dampingFraction: 0.85)) {
            movies.insert(movie, at: 0)
            lastAddedMovieID = movie.id
        }
    }
    
    func remove(_ movie: Movie) {
        withAnimation(.easeIn) {
            if let index = movies.firstIndex(of: movie) {
                movies.remove(at: index)
            }
        }
    }
    
    func binding(for id: UUID) -> Binding<Movie> {
        Binding(
            get: {
                self.movies.first(where: { $0.id == id })
                ?? Movie(id: id, title: "", genre: "", description: "", releaseYear: 0)
            },
            set: { updated in
                if let index = self.movies.firstIndex(where: { $0.id == id }) {
                    self.movies[index] = updated
                }
            }
        )
    }
    
    private func save() {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(movies) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }
    
    private func load() {
        let defaults = UserDefaults.standard
        let decoder = JSONDecoder()
        
        if let data = defaults.data(forKey: storageKey),
           let decoded = try? decoder.decode([Movie].self, from: data) {
            self.movies = decoded
        }
        
        sortOption = .none
        searchText = ""
    }
}
