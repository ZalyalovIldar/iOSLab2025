import SwiftUI
import Observation

struct FilmsListScreen: View {
    
    @Bindable var library: FilmLibrary
    @State private var showingAddFilm = false
    @State private var filmDraft = Film.draft
    
    var body: some View {
        NavigationStack {
            List {
                ForEach($library.films) { $film in
                    NavigationLink {
                        FilmEditorView(film: $film)
                    } label: {
                        FilmRowView(film: film)
                    }
                }
                .onDelete { indexSet in
                    library.remove(at: indexSet)
                }
            }
            .navigationTitle("Моя фильмотека")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        filmDraft = .draft
                        showingAddFilm = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("Добавить фильм")
                }
            }
            .sheet(isPresented: $showingAddFilm) {
                NavigationStack {
                    AddFilmView(
                        film: $filmDraft,
                        onCancel: {
                            showingAddFilm = false
                        },
                        onSave: { newFilm in
                            library.add(newFilm)
                            showingAddFilm = false
                        }
                    )
                }
            }
        }
    }
}

#Preview {
    FilmsListScreen(library: FilmLibrary())
}
