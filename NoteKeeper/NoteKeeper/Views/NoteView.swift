//
//  NoteView.swift
//  NoteKeeper
//
//  Created by Ляйсан on 02.10.2025.
//

import SwiftUI
//TODO: disable button, share!!!

struct NoteView: View {
    @State var noteViewModel: NotesViewModel
    @State var note: Note
    
    @Environment(\.dismiss)
    private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Title", text: $note.title)
                    .font(.largeTitle.bold())
                    .padding(5)
                TextEditor(text: $note.text)
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        noteViewModel.updateNote(id: note.id, title: note.title, text: note.text)
                        dismiss()
                    } label: {
                        Image(systemName: "checkmark")
                    }
                    .buttonStyle(.glassProminent)
                }
            }
        }
    }
}

#Preview {
    NoteView(noteViewModel: NotesViewModel(), note: Note(id: UUID(), title: "Hello", text: "World"))
}
