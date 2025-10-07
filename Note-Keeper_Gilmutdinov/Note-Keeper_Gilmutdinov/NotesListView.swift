import SwiftUI
import Observation

struct NotesListView: View {
    @Bindable var viewModel: NotesViewModel
    @State private var isAdding: Bool = false
    
    var body: some View {
        List {
            ForEach(viewModel.notes) { note in
                NoteRowView(note: note)
            }
            .onDelete(perform: removeNote)
        }
        .toolbar {
            ToolbarItem {
                Button(action: {
                    isAdding = true
                }) {
                    Image(systemName: "plus")
                        .font(.headline)
                }
            }
        }
        .sheet(isPresented: $isAdding) {
            AddNoteView(viewModel: viewModel, isPresented: $isAdding)
        }
    }
    
    private func removeNote(offsets: IndexSet) {
        for index in offsets {
            let note = viewModel.notes[index]
            viewModel.removeNote(note)
        }
    }
}
