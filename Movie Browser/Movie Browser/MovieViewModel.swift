import Foundation
import Observation

@Observable
class MovieViewModel {
    var movies: [Movie] = []
    var searchText: String = ""
    var sortOption: SortOption = .title
    
    enum SortOption: String, CaseIterable {
        case title = "По названию"
        case year = "По году"
    }
    
    private let userDefaultsKey = "savedMovies"
    
    init() {
        loadMovies()
    }
    
    var filteredAndSortedMovies: [Movie] {
        var filtered = movies
        
        if !searchText.trimmingCharacters(in: .whitespaces).isEmpty {
            let searchLower = searchText.lowercased().trimmingCharacters(in: .whitespaces)
            filtered = filtered.filter { movie in
                movie.title.lowercased().contains(searchLower) ||
                movie.genre.lowercased().contains(searchLower) ||
                movie.description.lowercased().contains(searchLower)
            }
        }
        
        switch sortOption {
        case .title:
            filtered.sort { $0.title.localizedCompare($1.title) == .orderedAscending }
        case .year:
            filtered.sort { $0.releaseYear > $1.releaseYear }
        }
        
        return filtered
    }
    
    func addMovie(_ movie: Movie) {
        movies.append(movie)
        saveMovies()
    }
    
    func deleteMovie(_ movie: Movie) {
        movies.removeAll { $0.id == movie.id }
        saveMovies()
    }
    
    func updateMovie(_ movie: Movie) {
        if let index = movies.firstIndex(where: { $0.id == movie.id }) {
            movies[index] = movie
            saveMovies()
        }
    }
    
    private func saveMovies() {
        if let encoded = try? JSONEncoder().encode(movies) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }
    
    private func loadMovies() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decoded = try? JSONDecoder().decode([Movie].self, from: data) {
            movies = decoded
        } else {
            movies = [
                Movie(title: "The Matrix", genre: "Sci-Fi", description: "A computer hacker learns from mysterious rebels about the true nature of his reality.", releaseYear: 1999),
                Movie(title: "Inception", genre: "Sci-Fi", description: "A thief who steals corporate secrets through dream-sharing technology.", releaseYear: 2010),
                Movie(title: "The Dark Knight", genre: "Action", description: "Batman faces the Joker, a criminal mastermind who seeks to undermine Batman.", releaseYear: 2008)
            ]
        }
    }
}
