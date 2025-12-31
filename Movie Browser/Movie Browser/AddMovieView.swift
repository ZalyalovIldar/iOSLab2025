import SwiftUI

struct AddMovieView: View {
    @Environment(\.dismiss)
    var dismiss
    @Bindable var viewModel: MovieViewModel
    
    @State private var title = ""
    @State private var genre = ""
    @State private var description = ""
    @State private var releaseYear = 2024
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Информация о фильме")) {
                    TextField("Название", text: $title)
                    TextField("Жанр", text: $genre)
                    
                    Picker("Год выпуска", selection: $releaseYear) {
                        ForEach(1900...2025, id: \.self) { year in
                            Text("\(year)").tag(year)
                        }
                    }
                }
                
                Section(header: Text("Описание")) {
                    TextEditor(text: $description)
                        .frame(minHeight: 100)
                }
            }
            .navigationTitle("Новый фильм")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Сохранить") {
                        let newMovie = Movie(
                            title: title,
                            genre: genre,
                            description: description,
                            releaseYear: releaseYear
                        )
                        withAnimation {
                            viewModel.addMovie(newMovie)
                        }
                        dismiss()
                    }
                    .disabled(title.isEmpty || genre.isEmpty)
                }
            }
        }
    }
}
