import Foundation

struct Note: Identifiable {
    let id = UUID()
    var title: String
    var content: String
}
import Observation
import SwiftUI

@Observable class NotesViewModel {
    private(set) var notes: [Note] = []
    
    func addNote(title: String, content: String) {
        let newNote = Note(title: title, content: content)
        notes.append(newNote)
    }
    
    func deleteNote(at indexSet: IndexSet) {
        notes.remove(atOffsets: indexSet)
    }
}
struct AddNoteView: View {
    @Bindable var viewModel: NotesViewModel
    @State private var title: String = ""
    @State private var content: String = ""
    
    var body: some View {
        VStack {
            TextField("Заголовок", text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextEditor(text: $content)
                .frame(height: 100)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                )
            
            Button("Добавить заметку") {
                viewModel.addNote(title: title, content: content)
                title = ""
                content = ""
            }
            .padding()
        }
        .padding()
    }
}
struct NoteRowView: View {
    var note: Note
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(note.title)
                .font(.headline)
            Text(note.content)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
    }
}
struct NotesListViev: View {
    @Bindable var viewModel: NotesViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.notes) { note in
                NoteRowView(note: note)
            }
            .onDelete { indexSet in
                viewModel.deleteNote(at: indexSet)
            }
        }
        .navigationTitle("Заметки")
    }
}
struct ContentView: View {
    @State private var viewModel = NotesViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                AddNoteView(viewModel: viewModel)
                NotesListView(viewModel: viewModel)
            }
        }
    }
}

struct NotesListView: View {
    @Bindable var viewModel: NotesViewModel
    @State private var searchText: String = ""
    
    var filteredNotes: [Note] {
        if searchText.isEmpty {
            return viewModel.notes
        } else {
            return viewModel.notes.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        VStack {
            TextField("Поиск...", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            List {
                ForEach(filteredNotes) { note in
                    NoteRowView(note: note)
                }
                .onDelete { indexSet in
                    viewModel.deleteNote(at: indexSet)
                }
            }
            .navigationTitle("Заметки (\(viewModel.notes.count))")
        }
    }
}
