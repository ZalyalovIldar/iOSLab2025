import SwiftUI

struct MovieDetailView: View {
    @Binding var movie: Movie
    @Bindable var viewModel: MovieViewModel
    let onDelete: () -> Void
    
    var body: some View {
        Form {
            Section {
                TextField("Название", text: $movie.title)
                TextField("Жанр", text: $movie.genre)
                
                Picker("Год выпуска", selection: $movie.releaseYear) {
                    ForEach(1900...2025, id: \.self) { year in
                        Text("\(year)").tag(year)
                    }
                }
            } header: {
                Text("Информация о фильме")
            }
            
            Section {
                TextEditor(text: $movie.description)
                    .frame(minHeight: 100)
            } header: {
                Text("Описание")
            }
            
            Section {
                Button(role: .destructive, action: onDelete) {
                    HStack {
                        Spacer()
                        Text("Удалить фильм")
                        Spacer()
                    }
                }
            }
        }
        .navigationTitle("Детали фильма")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: movie.title) { _, _ in
            viewModel.updateMovie(movie)
        }
        .onChange(of: movie.genre) { _, _ in
            viewModel.updateMovie(movie)
        }
        .onChange(of: movie.description) { _, _ in
            viewModel.updateMovie(movie)
        }
        .onChange(of: movie.releaseYear) { _, _ in
            viewModel.updateMovie(movie)
        }
    }
}

#Preview {
    NavigationStack {
        MovieDetailView(
            movie: .constant(Movie(title: "The Matrix", genre: "Sci-Fi", description: "A computer hacker learns from mysterious rebels about the true nature of his reality.", releaseYear: 1999)),
            viewModel: MovieViewModel(),
            onDelete: {}
        )
    }
}
