//
//  MoviesView.swift
//  MovieBrowser
//
//  Created by Ляйсан on 5/12/25.
//

import SwiftUI

struct MoviesView: View {
    @Bindable var movieViewModel: MovieViewModel
    
    @State private var isAddingMoviesSheetShown = false
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
           ZStack {
               background
               
               if movieViewModel.movies.isEmpty {
                   emptyState
               } else {
                   VStack(alignment: .leading) {
                       title
                           .padding()
                       movies
                           .padding(.horizontal, 10)
                       Spacer()
                   }
               }
           }
           .sheet(isPresented: $isAddingMoviesSheetShown) {
               CreateMovieView(movieViewModel: movieViewModel)
           }
           .navigationDestination(for: Movie.self) { movie in
               MovieDetailView(movie: binding(for: movie), movieViewModel: movieViewModel)
           }
           .toolbar {
               ToolbarItem(placement: .topBarLeading) {
                   Menu {
                       Menu {
                           sortButton
                       } label: {
                           HStack {
                               Image(systemName: "arrow.up.arrow.down")
                               Text("Sort by")
                           }
                       }
                   } label: {
                       Image(systemName: "line.3.horizontal.decrease")
                   }
               }
               ToolbarItem(placement: .topBarTrailing) {
                   plusButton
               }
               ToolbarItem(placement: .bottomBar) {
                   searchBar
               }
           }
        }
        
    }
    
    private func binding(for movie: Movie) -> Binding<Movie> {
        return Binding(get: {
            movieViewModel.movies.first { $0.id == movie.id } ?? movie
        }, set: { newValue in
            if let index = movieViewModel.movies.firstIndex(where: { $0.id == newValue.id }) {
                movieViewModel.movies[index] = newValue
                movieViewModel.saveMovies()
            }
        })
    }
    
    private var emptyState: some View {
        EmptyStateView(title: "No Movies", subTitle: "Tap the button below to add movie", imageName: "popcorn", buttonLabel: "New Movies") {
            isAddingMoviesSheetShown = true
        }
    }
    
    private var background: some View {
        LinearGradient(colors: [.vine, .black, .black, .black], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
    }
    
    private var title: some View {
        Text("Movies")
            .font(.largeTitle.bold())
    }
    
    private var movies: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(), GridItem()]) {
                ForEach(movieViewModel.filteredMovies) { movie in
                    MovieRowView(movie: movie, movieViewModel: movieViewModel)
                           .padding(5)
                           .onTapGesture {
                               path.append(movie)
                           }
                }
            }
        }
    }
    
    private var plusButton: some View {
        Button {
            isAddingMoviesSheetShown = true
        } label: {
            Image(systemName: "plus")
                .foregroundStyle(.white.opacity(0.8))
        }
        .buttonStyle(.glassProminent)
        .tint(.vine)
    }
    
    private var sortButton: some View {
        Button {
            movieViewModel.isSortedByTitle.toggle()
        } label: {
            HStack {
                 Image(systemName: movieViewModel.isSortedByTitle
                      ? "checkmark" : "")
                Text("Title")
            }
        }
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.leading, 5)
            TextField("Search", text: $movieViewModel.searchText)
        }
    }
}

#Preview {
    MoviesView(movieViewModel: MovieViewModel())
}
