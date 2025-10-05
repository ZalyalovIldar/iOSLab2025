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
        VStack {
            
            TitleView()
            
            AddNewNoteView(viewModel: viewModel)
            
            NoteListView(viewModel: viewModel)
            
        }
        .padding()
    }
}

struct TitleView: View {
    
    var body: some View {
        
        Text("Note Keeper")
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundStyle(Gradient(colors: [.black, .gray]))
            .shadow(color: .blue.opacity(0.5), radius: 10, x: 2, y: 5)
    }
}

struct NoteListView: View {
    
    @Bindable var viewModel: NoteViewModel
    
    var body: some View {
        List {
            
            ForEach($viewModel.notes) { $note in
                NoteRowView(note: $note)
            }
            .onDelete(perform: viewModel.deleteNote)
        }
    }
}

struct NoteRowView: View {
    
    @Binding var note: Note
    
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
                        lineWidth: 2)
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

#Preview {
    ContentView()
}
