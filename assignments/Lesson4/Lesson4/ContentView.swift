//
//  ContentView.swift
//  Lesson4
//
//  Created by Timur Minkhatov on 07.10.2025.
//

import SwiftUI

struct TasksViewContainer: View {
    
    @State private var viewModel = TasksViewModel()
    @State private var newNoteTitle: String = ""
    @State private var newNoteContent: String = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack {
                    Text("Мои заметки")
                        .font(.title2)
                        .fontWeight(.semibold)
                    Spacer()
                    Text("Количество заметок: \(viewModel.notesCount)")
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue)
                        .clipShape(Capsule())
                }
                .padding(.horizontal)
                .padding(.top)
                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    TextField("Поиск по заметкам", text: $viewModel.searchText)
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal)
                .padding(.top, 8)
                
                AddNoteView(
                    newNoteTitle: $newNoteTitle,
                    newNoteContent: $newNoteContent
                ) {
                    viewModel.addNote(title: newNoteTitle, content: newNoteContent)
                    newNoteTitle = ""
                    newNoteContent = ""
                }
                
                NotesListView(viewModel: viewModel)
            }
        }
    }
}

struct AddNoteView: View {
    
    @Binding var newNoteTitle: String
    @Binding var newNoteContent: String
    
    let onAdd: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            TextField("Заголовок", text: $newNoteTitle)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.system(size: 16))
            
            TextField("Текст заметки", text: $newNoteContent, axis: .vertical)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .lineLimit(2...3)
                .font(.system(size: 14))
            
            Button(action: onAdd) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Добавить")
                        .fontWeight(.medium)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
            }
            .buttonStyle(.borderedProminent)
            .disabled(newNoteTitle.isEmpty || newNoteContent.isEmpty)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.1), radius: 2, x: 0, y: 1)
        .padding(.horizontal)
        .padding(.top, 8)
    }
}

struct NotesListView: View {
    
    @Bindable var viewModel: TasksViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.filteredNotes) { note in
                NoteRowView(note: note)
                    .padding(.vertical, 4)
            }
            .onDelete(perform: viewModel.removeNote)
        }
        .listStyle(PlainListStyle())
        .overlay {
            if viewModel.filteredNotes.isEmpty {
                ContentUnavailableView(
                    viewModel.searchText.isEmpty ? "Нет заметок" : "Ничего не найдено",
                    systemImage: viewModel.searchText.isEmpty ? "note.text" : "magnifyingglass",
                    description: Text(viewModel.searchText.isEmpty ? "Добавьте первую заметку" : "Попробуйте изменить запрос")
                )
            }
        }
    }
}

struct NoteRowView: View {
    let note: Note
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(note.title)
                .font(.headline)
                .foregroundColor(.primary)
                .lineLimit(1)
            
            Text(note.content)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(2)
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
    }
}

#Preview {
    TasksViewContainer()
}
