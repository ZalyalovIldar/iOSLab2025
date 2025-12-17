//
//  MovieDetailView.swift
//  MovieBrowser
//
//  Created by krnklvx on 04.12.2025.
//

import SwiftUI

struct MovieDetailView: View {
    @Binding var movie: Movie
    let viewModel: MoviesViewModel
    
    var body: some View {
        Form {
            Section("Poster") {
                HStack {
                    Spacer()
                    Image(systemName: movie.posterSymbol)
                        .font(.system(size: 60))
                        .foregroundStyle(.blue)
                    Spacer()
                }
                .padding()
                
                Picker("Poster Symbol", selection: $movie.posterSymbol) {
                    Text("Film").tag("film.fill")
                    Text("Eye").tag("eye.fill")
                    Text("Sparkles").tag("sparkles")
                    Text("Shield").tag("shield.fill")
                    Text("Star").tag("star.fill")
                    Text("Heart").tag("heart.fill")
                    Text("Flame").tag("flame.fill")
                    Text("Crown").tag("crown.fill")
                }
            }
            
            Section("Title") {
                TextField("Title", text: $movie.title)
            }
            
            Section("Genre") {
                TextField("Genre", text: $movie.genre)
            }
            
            Section("Description") {
                TextField("Description", text: $movie.description, axis: .vertical)
                    .lineLimit(5...10)
            }
            
            Section("Release Year") {
                Stepper("\(movie.releaseYear)", value: $movie.releaseYear, in: 1900...2025)
            }
        }
        .navigationTitle("Edit Movie")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: movie) { oldValue, newValue in
            viewModel.updateMovie(newValue)
        }
    }
}

#Preview {
    NavigationStack {
        MovieDetailView(
            movie: .constant(Movie(
                title: "The Matrix",
                genre: "Sci-Fi",
                description: "A computer hacker learns about the true nature of reality.",
                releaseYear: 1999,
                posterSymbol: "eye.fill"
            )),
            viewModel: MoviesViewModel()
        )
    }
}
