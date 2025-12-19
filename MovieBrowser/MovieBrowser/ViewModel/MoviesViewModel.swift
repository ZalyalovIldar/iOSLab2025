//
//  MovieViewModel.swift
//  MovieBrowser
//
//  Created by Artur Bagautdinov on 17.12.2025.
//

import SwiftUI

@Observable
class MoviesViewModel {
    var movies: [Movie] = [
        .init(title: "Inception",
              genre: "Sci-Fi",
              description: "A thief who steals corporate secrets through dream-sharing technology.",
              releaseYear: 2010),
        .init(title: "Interstellar",
              genre: "Sci-Fi",
              description: "Explorers travel through a wormhole in space.",
              releaseYear: 2014),
        .init(title: "The Dark Knight",
              genre: "Action",
              description: "Batman faces the Joker in Gotham City.",
              releaseYear: 2008)
    ]
    
    func add(movie: Movie) {
        movies.append(movie)
    }
    
    func remove(_ movie: Movie) {
        if let index = movies.firstIndex(of: movie) {
            movies.remove(at: index)
        }
    }

}
