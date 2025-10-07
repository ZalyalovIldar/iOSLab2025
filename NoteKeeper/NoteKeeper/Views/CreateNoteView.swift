//
//  CreateNoteView.swift
//  NoteKeeper
//
//  Created by Ляйсан on 01.10.2025.
//

import SwiftUI

struct CreateNoteView: View {
    @State var notesViewModel: NotesViewModel
    @State private var noteTitle = ""
    @State private var noteText = ""
    
    @Environment(\.dismiss)
    private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Title", text: $noteTitle)
                    .font(.largeTitle.bold())
                    .padding(5)
                TextEditor(text: $noteText)
            }
            .padding()
            .toolbar {
                ToolbarItem {
                    Button {
                        if !noteTitle.isEmpty && !noteText.isEmpty {
                            let note = Note(id: UUID(), title: noteTitle, text: noteText)
                            notesViewModel.addNote(note)
                            dismiss()
                        }
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
    CreateNoteView(notesViewModel: NotesViewModel())
}
