//
//  MovieViewModel.swift
//  MovieBrowser
//
//  Created by Artur Bagautdinov on 17.12.2025.
//

import SwiftUI

import SwiftUI

@Observable
final class MoviesViewModel {
    
    enum SortOption: Hashable {
        case none
        case title
        case year
    }
    
    var movies: [Movie] = [
        .init(title: "Inception",
              genre: "Sci-Fi",
              description: "A thief who steals corporate secrets through dream-sharing technology.",
              releaseYear: 2010),
        .init(title: "The Dark Knight",
              genre: "Action",
              description: "Batman faces the Joker in Gotham City.",
              releaseYear: 2008)
    ]
    
    var searchText: String = ""
    var sortOption: SortOption = .none
    
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
        movies.append(movie)
    }
    
    func remove(_ movie: Movie) {
        if let index = movies.firstIndex(of: movie) {
            movies.remove(at: index)
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
}
