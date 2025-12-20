//
//  ContentView.swift
//  MovieBrowser
//
//  Created by Artur Bagautdinov on 17.12.2025.
//

import SwiftUI

import SwiftUI

struct MoviesListView: View {
    
    @State var viewModel = MoviesViewModel()
    @State private var showingAddSheet = false
    @State private var path = NavigationPath()
    
    private let columns = [
        GridItem(.adaptive(minimum: 150), spacing: 16)
    ]
    
    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(viewModel.filteredMovies) { movie in
                        Button {
                            path.append(movie.id)
                        } label: {
                            MovieRowView(movie: movie)
                                .contextMenu {
                                    Button(role: .destructive) {
                                        viewModel.remove(movie)
                                    } label: {
                                        Label("Удалить", systemImage: "trash")
                                    }
                                }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 16)
                .padding(.bottom, 32)
            }
            .scrollIndicators(.hidden)
            .background(Color.backgroundColor)
            .navigationTitle("Movies")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        Picker("Sort by", selection: $viewModel.sortOption) {
                            Text("None")
                                .tag(MoviesViewModel.SortOption.none)
                            Text("Title (A -> Z)")
                                .tag(MoviesViewModel.SortOption.title)
                            Text("Year (Old -> New)")
                                .tag(MoviesViewModel.SortOption.year)
                        }
                        .pickerStyle(.automatic)
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .searchable(text: $viewModel.searchText)
            .navigationDestination(for: UUID.self) { movieID in
                MovieDetailView(movie: viewModel.binding(for: movieID))
            }
            .sheet(isPresented: $showingAddSheet) {
                NavigationStack {
                    AddMovieView(viewModel: viewModel)
                }
            }
        }
    }
}

#Preview {
    MoviesListView(viewModel: MoviesViewModel())
}
