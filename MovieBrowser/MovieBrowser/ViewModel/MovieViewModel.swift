//
//  MovieViewModel.swift
//  MovieBrowser
//
//  Created by Ляйсан on 5/12/25.
//

import Foundation
import SwiftUI

@Observable
final class MovieViewModel {
    var movies: [Movie] = []
    
    var searchText = ""
    var title = ""
    var description: String = ""
    var selectedGenre = Genre.comedy
    var releaseYear = 2010
    var isSortedByTitle = false
    
    var filteredMovies: [Movie] {
        var allMovies = movies
        
        if !searchText.isEmpty {
            allMovies = movies.filter { $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.genre.rawValue.localizedCaseInsensitiveContains(searchText) }
        }
        
        if isSortedByTitle {
            allMovies = allMovies.sorted { $0.title < $1.title }
        }
        return allMovies
    }
    
    private var userDefaultsKey =  "movies"
    private var imagesFolderName = "movie_images"
    
    init() {
        getMovies()
    }
    
    func getMovies() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let movies = try? JSONDecoder().decode([Movie].self, from: data) {
            self.movies = movies
        }
    }
    
    func addMovie(image: UIImage?, imageName: String) {
        let movie = Movie(title: title, genre: selectedGenre, description: description, releaseYear: releaseYear, imageName: imageName)
        movies.append(movie)
    
        if let image {
            saveImage(image: image, imageName: imageName)
        }
        saveMovies()
        
        title = ""
        description = ""
        releaseYear = 2010
    }
    
    func updatePoster(image: UIImage, imageName: String, movieId: String) {
        if let index = movies.firstIndex(where: { $0.id == movieId }) {
            movies[index].imageName = imageName
            saveImage(image: image, imageName: imageName)
            saveMovies()
        }
    }
    
    func getPoster(imageName: String) -> UIImage? {
        LocalFileManager.shared.getImage(imageName: imageName, folderName: imagesFolderName)
    }
    
    func delete(movieId: String) {
        if let index = movies.firstIndex(where: { $0.id == movieId }) {
            deletePoster(imageName: movies[index].imageName)
            movies.remove(at: index)
            
            saveMovies()
        }
    }
    
    func saveMovies() {
        if let data = try? JSONEncoder().encode(movies) {
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        }
    }
    
    private func saveImage(image: UIImage, imageName: String) {
        LocalFileManager.shared.save(image: image, imageName: imageName, folderName: imagesFolderName)
    }
    
    private func deletePoster(imageName: String) {
        LocalFileManager.shared.delete(imageName: imageName, folderName: imagesFolderName)
    }
}
