//
//  ContentView.swift
//  MovieBrowser
//
//  Created by Artur Bagautdinov on 17.12.2025.
//

import SwiftUI

struct MoviesListView: View {
    
    @State var viewModel = MoviesViewModel()
    @State private var showingAddSheet = false
    @State private var path = NavigationPath()
    @State private var highlightedID: UUID?
    @State private var removingID: UUID?
    
    @Namespace private var navNamespace
    
    private let columns = [
        GridItem(.adaptive(minimum: 150), spacing: 16)
    ]
    
    var body: some View {
        
        NavigationStack(path: $path) {
            
            ScrollView {
                
                if viewModel.filteredMovies.isEmpty {
                    
                    VStack {
                        
                        Spacer(minLength: 80)
                        
                        EmptyStateView(
                            title: viewModel.searchText.isEmpty ? "No movies yet" : "No movies found",
                            message: viewModel.searchText.isEmpty
                                ? "Add your first movie to start your collection."
                                : "No movies match your search query.",
                            buttonTitle: "Add movie"
                        ) {
                            showingAddSheet = true
                        }
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                } else {
                    
                    LazyVGrid(columns: columns, spacing: 16) {
                        
                        ForEach(viewModel.filteredMovies) { movie in
                            
                            let isHighlighted = (highlightedID == movie.id)
                            let isRemoving = (removingID == movie.id)
                            
                            Button {
                                path.append(movie.id)
                            } label: {
                                MovieRowView(movie: movie)
                                    .scaleEffect(isHighlighted ? 1.05 : 1.0)
                                    .shadow(
                                        color: isHighlighted ? Color.pink : Color.black.opacity(0.1),
                                        radius: isHighlighted ? 10 : 4,
                                        x: 0,
                                        y: 2
                                    )
                                    .scaleEffect(isRemoving ? 0.95 : 1)
                                    .animation(.easeOut(duration: 0.2), value: isRemoving)
                                    .opacity(isRemoving ? 0 : 1)
                                    .contextMenu {
                                        Button(role: .destructive) {
                                            removingID = movie.id
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.22) {
                                                viewModel.remove(movie)
                                                removingID = nil
                                            }
                                        } label: {
                                            Label("Удалить", systemImage: "trash")
                                        }
                                    }
                                    .navigationTransition(.zoom(sourceID: movie.id, in: navNamespace))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 16)
                    .padding(.bottom, 32)
                }
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
                    .navigationTransition(.zoom(sourceID: movieID, in: navNamespace))
            }
            .sheet(isPresented: $showingAddSheet) {
                NavigationStack {
                    AddMovieView(viewModel: viewModel)
                }
            }
            .onChange(of: viewModel.lastAddedMovieID) {
                highlightedID = viewModel.lastAddedMovieID
                guard highlightedID != nil else { return }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.22) {
                    withAnimation(.spring(response: 3, dampingFraction: 0.7)) {
                        highlightedID = nil
                    }
                }
            }

        }
    }
}

#Preview {
    MoviesListView(viewModel: MoviesViewModel())
}
