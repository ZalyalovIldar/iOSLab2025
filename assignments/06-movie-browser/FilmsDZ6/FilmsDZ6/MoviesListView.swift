//
//  MoviesListView.swift
//  FilmsDZ6
//
//  Created by Иван Метальников on 11.12.2025.
//

import Foundation
import SwiftUI


struct MoviesListView: View{
    
    @Bindable var movieViewModel: MovieViewModel
    @State var newFilmTitle: String = ""
    @State private var selectedMovie: Movie?
    
    var body: some View {
        NavigationStack{
            List{
                Section("Добавить фильм"){
                    HStack{
                        TextField("Название фильма",text: $newFilmTitle)
                        Button("Add"){
                            movieViewModel.addMovie(title: newFilmTitle)
                            newFilmTitle = ""
                            selectedMovie = movieViewModel.movies.first
                        }
                        .disabled(newFilmTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                }
                Section("Фильмы"){
                    ForEach($movieViewModel.movies){ $movie in
                        NavigationLink {
                            MovieEditView(movie: $movie)
                        } label: {
                            MovieRow(movie: movie)
                        }
                    }
                    .onDelete(perform: movieViewModel.deleteMovie)
                }
            }
            .navigationTitle("Фильмы")
            .navigationDestination(item: $selectedMovie) { movie in
                MovieEditView(movie: binding(for: movie))
            }
        }
    }
    
    private func binding(for movie: Movie) -> Binding<Movie> {
        let index = movieViewModel.movies.firstIndex { $0.id == movie.id }!
        return $movieViewModel.movies[index]
    }
}

struct MovieRow: View {
    var movie: Movie
    
    var body: some View {
        VStack{
            Text(movie.title)
                .font(.headline)
            Text(movie.description)
                .font(.caption)
        }
    }
}
