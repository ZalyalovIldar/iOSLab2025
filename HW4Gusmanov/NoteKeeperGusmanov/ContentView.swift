import SwiftUI

struct ContentView: View {
    @State private var notes: [Note] = []
    @State private var searchText = ""
    
    var filteredNotes: [Note] {
        if searchText.isEmpty {
            return notes
        } else {
            return notes.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                AddNoteView { title, text in
                    let newNote = Note(title: title, text: text)
                    notes.append(newNote)
                }
                
                NotesListView(
                    notes: filteredNotes,
                    onDelete: { indexSet in
                        notes.remove(atOffsets: indexSet)
                    }
                )
                
                Spacer()
            }
            .navigationTitle("Заметки")
            .searchable(text: $searchText, prompt: "Поиск по заголовку")
        }
    }
}
