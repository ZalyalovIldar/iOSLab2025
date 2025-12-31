import SwiftUI

struct MoviesListView: View {
    @State private var viewModel = MovieViewModel()
    @State private var path = NavigationPath()
    @State private var showingAddMovie = false
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                if viewModel.filteredAndSortedMovies.isEmpty {
                    ContentUnavailableView(
                        "Фильмы не найдены",
                        systemImage: "film",
                        description: Text(viewModel.searchText.isEmpty ? "Добавьте первый фильм" : "Попробуйте другой поисковый запрос")
                    )
                } else {
                    List {
                        ForEach(viewModel.filteredAndSortedMovies) { movie in
                            NavigationLink(value: movie) {
                                MovieRowView(movie: movie)
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button(role: .destructive) {
                                    withAnimation {
                                        viewModel.deleteMovie(movie)
                                    }
                                } label: {
                                    Label("Удалить", systemImage: "trash")
                                }
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                    .animation(.default, value: viewModel.filteredAndSortedMovies)
                }
            }
            .navigationTitle("Фильмы")
            .searchable(text: $viewModel.searchText, prompt: "Поиск фильмов")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Picker("Сортировка", selection: $viewModel.sortOption) {
                            ForEach(MovieViewModel.SortOption.allCases, id: \.self) { option in
                                Text(option.rawValue).tag(option)
                            }
                        }
                    } label: {
                        Label("Сортировка", systemImage: "arrow.up.arrow.down")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddMovie = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddMovie) {
                AddMovieView(viewModel: viewModel)
            }
            .navigationDestination(for: Movie.self) { movie in
                MovieDetailView(
                    movie: binding(for: movie),
                    viewModel: viewModel,
                    onDelete: {
                        withAnimation {
                            viewModel.deleteMovie(movie)
                        }
                        path.removeLast()
                    }
                )
            }
        }
    }
    
    private func binding(for movie: Movie) -> Binding<Movie> {
        guard let index = viewModel.movies.firstIndex(where: { $0.id == movie.id }) else {
            fatalError("Movie not found")
        }
        return $viewModel.movies[index]
    }
}

#Preview {
    MoviesListView()
}
