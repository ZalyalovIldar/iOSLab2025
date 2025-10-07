import Foundation
import SwiftUI
import Observation


struct Note: Identifiable, Codable {
    let id: UUID
    var title: String
    var text: String
    let createdAt: Date

    init(title: String, text: String) {
        self.id = UUID()
        self.title = title
        self.text = text
        self.createdAt = Date()
    }
}


@Observable
final class NotesViewModel {
    var notes: [Note] = [] {
        didSet {
            saveNotes()
        }
    }
    var searchText: String = ""

    var filteredNotes: [Note] {
        guard !searchText.isEmpty else {
            return notes
        }
        return notes.filter { note in
            note.title.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    private let userDefaultsKey = "savedNotes"

    init() {
        loadNotes()
    }

    func addNote(title: String, text: String) {
        let newNote = Note(title: title, text: text)
        notes.insert(newNote, at: 0)
    }

    func removeNote(at offsets: IndexSet) {
        notes.remove(atOffsets: offsets)
    }
    
    private func saveNotes() {
        if let encodedData = try? JSONEncoder().encode(notes) {
            UserDefaults.standard.set(encodedData, forKey: userDefaultsKey)
        }
    }
    
    private func loadNotes() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decodedNotes = try? JSONDecoder().decode([Note].self, from: data) {
            self.notes = decodedNotes
            return
        }
        self.notes = []
    }
}


struct NotesContainerView: View {
    @State private var viewModel = NotesViewModel()

    var body: some View {
        VStack(spacing: 0) {
            AddNoteView(viewModel: viewModel)
            
            Divider()

            NotesListView(viewModel: viewModel)
        }
        .padding()
        .navigationTitle("My Notes")
        .searchable(text: $viewModel.searchText, prompt: "Search by title")
    }
}

struct AddNoteView: View {
    var viewModel: NotesViewModel
    
    @State private var noteTitle: String = ""
    @State private var noteText: String = ""

    var body: some View {
        VStack {
            TextField("Note Title", text: $noteTitle)
                .textFieldStyle(.roundedBorder)
            
            TextField("Note Text...", text: $noteText)
                .textFieldStyle(.roundedBorder)
            
            Button("Add Note") {
                guard !noteTitle.isEmpty else { return }
                
                viewModel.addNote(title: noteTitle, text: noteText)
                
                noteTitle = ""
                noteText = ""
            }
            .buttonStyle(.borderedProminent)
            .frame(maxWidth: .infinity, alignment: .trailing)
            
        }
        .padding(.bottom)
    }
}

struct NotesListView: View {
    @Bindable var viewModel: NotesViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Text("Notes: \(viewModel.filteredNotes.count)")
                .font(.footnote)
                .foregroundColor(.secondary)
                .padding(.top, 5)

            List {
                ForEach(viewModel.filteredNotes) { note in
                    NoteRowView(note: note)
                }
                .onDelete(perform: viewModel.removeNote)
            }
            .listStyle(.plain)
        }
    }
}

struct NoteRowView: View {
    let note: Note

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(note.title)
                .font(.headline)
            
            if !note.text.isEmpty {
                Text(note.text)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 5)
    }
}


@main
struct NoteKeeperApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                NotesContainerView()
            }
        }
    }
}


#Preview {
    NavigationView {
        NotesContainerView()
    }
}
