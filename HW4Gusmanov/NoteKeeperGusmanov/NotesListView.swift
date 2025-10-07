import SwiftUI

struct NotesListView: View {
    let notes: [Note]
    let onDelete: (IndexSet) -> Void
    
    var body: some View {
        List {
            ForEach(notes) { note in
                NoteRowView(note: note)
            }
            .onDelete(perform: onDelete)
        }
        .listStyle(PlainListStyle())
    }
}
