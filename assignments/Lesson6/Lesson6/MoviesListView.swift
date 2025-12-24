//
//  MoviesListView.swift
//  Lesson6
//
//  Created by Timur Minkhatov on 22.12.2025.
//

import SwiftUI

struct MoviesListView: View {
    @Bindable var viewModel: MoviesViewModel
    @State private var showingAddMovie = false
    
    var body: some View {
        NavigationStack(path: $viewModel.navigationPath) {
            List {
                ForEach(viewModel.filteredAndSortedMovies) { movie in
                    NavigationLink(value: movie) {
                        MovieRowView(movie: movie)
                    }
                }
                .onDelete(perform: viewModel.deleteMovies)
            }
            .navigationTitle("Movies")
            .searchable(text: $viewModel.searchText, prompt: "Search movies")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        Picker("Sort by", selection: $viewModel.sortOption) {
                            ForEach(MoviesViewModel.SortOption.allCases, id: \.self) { option in
                                Label(option.displayName, systemImage: option == .title ? "textformat" : "calendar")
                                    .tag(option)
                            }
                        }
                    } label: {
                        Label("Sort", systemImage: "arrow.up.arrow.down")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddMovie = true
                    } label: {
                        Label("Add Movie", systemImage: "plus")
                    }
                }
            }
            .navigationDestination(for: Movie.self) { movie in
                if let index = viewModel.movies.firstIndex(where: { $0.id == movie.id }) {
                    MovieDetailView(movie: $viewModel.movies[index])
                        .onDisappear {
                            viewModel.saveMovies()
                        }
                }
            }
            .sheet(isPresented: $showingAddMovie) {
                AddMovieView { newMovie in
                    withAnimation {
                        viewModel.addMovie(newMovie)
                    }
                }
            }
            .overlay {
                if viewModel.filteredAndSortedMovies.isEmpty {
                    emptyStateView
                }
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: viewModel.searchText.isEmpty ? "film.stack" : "magnifyingglass")
                .font(.system(size: 60))
                .foregroundStyle(.secondary)
            
            Text(viewModel.searchText.isEmpty ? "No Movies" : "No Results")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text(viewModel.searchText.isEmpty ? "Add your first movie to get started" : "Try a different search term")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            if viewModel.searchText.isEmpty {
                Button {
                    showingAddMovie = true
                } label: {
                    Label("Add Movie", systemImage: "plus.circle.fill")
                        .font(.headline)
                }
                .buttonStyle(.borderedProminent)
                .padding(.top, 8)
            }
        }
        .padding()
    }
}
