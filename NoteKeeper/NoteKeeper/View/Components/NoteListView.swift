//
//  NoteListView.swift
//  NoteKeeper
//
//  Created by Artur Bagautdinov on 07.10.2025.
//

import SwiftUI

struct NoteListView: View {
    
    @Bindable var viewModel: NoteViewModel
    @Binding var noteToEdit: Note?
    
    var body: some View {
        
        List {
            
            ForEach(viewModel.filteredNotes) { note in
                NoteRowView(note: note, noteToEdit: $noteToEdit)
            }
            .onDelete(perform: viewModel.deleteNote)
            
        }
        .padding()
        .listStyle(.plain)
        .overlay {
            if viewModel.filteredNotes.isEmpty {
                
                if viewModel.searchText.isEmpty {
                    
                    ContentUnavailableView(
                        "No Notes Created",
                        systemImage: "note.text.badge.plus",
                        description: Text("Fill out the form above to create your first note and start organizing your thoughts")
                    )
                } else {
                    
                    ContentUnavailableView(
                        "No Notes Found",
                        systemImage: "magnifyingglass",
                        description: Text("No notes found for '\(viewModel.searchText)'. Try again with a different search term")
                    )
                }
            }
        }
        
        HStack {
            
            NotesCountView(viewModel: viewModel)
            
            Spacer()
            
            ClearAllButton(viewModel: viewModel)
        }
        .padding(.horizontal)
    }
}

#Preview {
    let viewModel = NoteViewModel()
    viewModel.notes = [
        Note(title: "Test 1", text: "Sample note text"),
        Note(title: "Test 2", text: "Another sample note")
    ]
    return NoteListView(viewModel: viewModel, noteToEdit: .constant(nil))
}
