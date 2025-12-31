import SwiftUI

struct FilmEditorView: View {
    @Binding var film: Film
    
    var body: some View {
        Form {
            Section("Информация о фильме") {
                TextField("Название", text: $film.name)
                    .textInputAutocapitalization(.words)
                
                TextField("Жанр", text: $film.category)
                
                TextField("Год выхода", value: $film.year, format: .number)
                    .keyboardType(.numberPad)
            }
            
            Section("Заметки") {
                TextEditor(text: $film.notes)
                    .frame(minHeight: 160)
            }
        }
        .navigationTitle(film.name.isEmpty ? "Фильм" : film.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        FilmEditorView(film: .constant(Film.demo[0]))
    }
}
