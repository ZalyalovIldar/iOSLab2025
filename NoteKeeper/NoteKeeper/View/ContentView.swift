//
//  ContentView.swift
//  NoteKeeper
//
//  Created by Artur Bagautdinov on 05.10.2025.
//

import SwiftUI

struct ContentView: View {
    
    @State var viewModel = NoteViewModel()
    
    var body: some View {
        
        NavigationStack {
            
            VStack {
                
                TitleView()
                
                AddNewNoteView(viewModel: viewModel)
                
                NoteListView(viewModel: viewModel)
                
            }
            .padding()
            .searchable(
                text: $viewModel.searchText,
                prompt: "Search by title"
            )
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
}

struct TitleView: View {
    
    var body: some View {
        
        Text("Note Keeper")
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundStyle(Gradient(colors: [.black, .gray]))
    }
}

struct NoteListView: View {
    
    @Bindable var viewModel: NoteViewModel
    
    var body: some View {
        List {
            
            ForEach(viewModel.filteredNotes) { note in
                NoteRowView(note: note)
            }
            .onDelete(perform: viewModel.deleteNote)
        }
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
    }
}

struct NoteRowView: View {
    
    let note: Note
    
    var body: some View {
        VStack(spacing: 12) {
            
            Text(note.title)
                .font(.headline)
            
            Divider()
                .background(LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing))
            
            Text(note.text)
                .font(.body)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemGray6))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(LinearGradient(
                            colors: [.blue.opacity(0.3), .purple.opacity(0.3)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 3)
                )
        )
    }
}

struct AddNewNoteView: View {
    
    @Bindable var viewModel: NoteViewModel
    
    var body: some View {
        
        VStack(spacing: 10) {
            
            TextField("Add title", text: $viewModel.newNoteName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Add body", text: $viewModel.newNoteText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .submitLabel(.done)
                .onSubmit {
                    hideKeyboard()
                }
            
            if let error = viewModel.formErrorMessage {
                Text(error)
                    .foregroundStyle(.red)
                    .font(.caption)
                
            }
            
            Button {
                
                let newNote = Note(title: viewModel.newNoteName, text: viewModel.newNoteText)
                viewModel.addNote(note: newNote)
                
            } label: {
                Text("Add Note")
                    .font(.headline)
                    .foregroundColor(.white)
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Color.blue)
                            .frame(width: 95, height: 30)
                    )
            }
        }
    }
}

extension View {
    
    func hideKeyboard() {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
}

#Preview {
    ContentView()
}
