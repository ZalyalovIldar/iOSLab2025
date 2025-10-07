//
//  ContentView.swift
//  NoteKeeper
//
//  Created by Artur Bagautdinov on 05.10.2025.
//

import SwiftUI

struct ContentView: View {
    
    @State var viewModel = NoteViewModel()
    @State var showAddForm = true
    
    var body: some View {
        
        NavigationStack {
            
            VStack {
                
                TitleView()
                
                if showAddForm {
                    AddNewNoteView(viewModel: viewModel)
                        .transition(.opacity.animation(.easeInOut))
                }
                
                FormButtonView(showAddForm: $showAddForm)
                
                SortPickerView(viewModel: viewModel)
                
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

struct NotesCountView: View {
    
    @Bindable var viewModel: NoteViewModel
    
    var body: some View {
        
        Text("Notes count: \(viewModel.filteredNotes.count)")
            .font(.system(size: 16))
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color(.systemGray5))
                    .frame(width: 120, height: 27)
            )
    }
}

struct ClearAllButton: View {
    
    @Bindable var viewModel: NoteViewModel
    
    @State var showConfirmation: Bool = false
    
    var body: some View {
        
        Button {
            showConfirmation = true
        } label: {
            HStack {
                
                Image(systemName: "trash")
                Text("Clear All")
                
            }
            .foregroundStyle(.red)
            .font(.system(size: 16))
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color(.systemGray5))
                    .frame(width: 115, height: 27)
            )
        }
        .alert("Delete All notes?", isPresented: $showConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete All") {
                viewModel.deleteAllNotes()
            }
        } message: {
            Text("This will permanently delete all \(viewModel.totalNotesCount) notes. This action cannot be undone.")
        }
    }
}

struct NoteRowView: View {
    
    let note: Note
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    var body: some View {
        
        VStack() {
            
            VStack(spacing: 12) {
                
                Text(note.title)
                    .font(.headline)
                    .fontWeight(.bold)
                
                Divider()
                    .background(LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing))
                
                Text(note.text)
                    .font(.body)
                
            }
            
            VStack {
                
                Divider()
                
                Text("Created: \(dateFormatter.string(from: note.createdDate))")
                    .font(.caption)
                    .foregroundStyle(.gray)
                
            }
            .padding(.top, 8)
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
        .frame(width: 330)
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
            
            Divider()
            
        }
    }
}

struct FormButtonView: View {
    
    @Binding var showAddForm: Bool
    
    var body: some View {
        
        VStack(spacing: 6) {
            
            Button {
                withAnimation(.easeInOut) {
                    showAddForm.toggle()
                }
            } label: {
                Label(showAddForm ? "hide the form" : "add the note", systemImage: showAddForm ? "chevron.up.circle" : "plus.circle")
                    .font(.headline)
                    .foregroundColor(.blue)
            }
            
            Divider()
            
        }
    }
}

struct SortPickerView: View {
    
    @Bindable var viewModel: NoteViewModel
    
    var body: some View {
        
        HStack {
            
            Text("Sort:")
                .font(.subheadline)
            
            Picker("Sort by:", selection: $viewModel.sortOption) {
                ForEach(SortOption.allCases, id: \.self) { option in
                    Text(option.rawValue)
                        .tag(option)
                }
            }
            .pickerStyle(.menu)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(.gray.opacity(0.2))
                    
            )
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
