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
                    Text("Количество моих заметок: \(viewModel.notesCount)")
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.blue)
                        .clipShape(Capsule())
                    
                    Spacer()
                    
                    Menu {
                        ForEach(TasksViewModel.SortOption.allCases, id: \.self) { option in
                            Button {
                                viewModel.chooseSort(option)
                            } label: {
                                HStack {
                                    Text(option.title)
                                    if viewModel.sortOption == option {
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                        }
                    } label: {
                        HStack {
                            Image(systemName: "arrow.up.arrow.down")
                            Text("Сортировка")
                        }
                        .font(.caption)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.gray.opacity(0.1))
                        .foregroundColor(.primary)
                        .cornerRadius(8)
                    }
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
    @State private var showingEditSheet = false
    @State private var selectedNote: Note?
    
    let viewModel: TasksViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.filteredNotes) { note in
                NoteRowView(note: note) { note in
                    selectedNote = note
                    showingEditSheet = true
                }
                .padding(.vertical, 4)
            }
            .onDelete(perform: viewModel.removeNote)
        }
        .listStyle(PlainListStyle())
        .sheet(isPresented: $showingEditSheet) {
            if let note = selectedNote {
                EditNoteView(note: note) { newTitle, newContent in
                    viewModel.updateNote(id: note.id, newTitle: newTitle, newContent: newContent)
                }
            }
        }
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
    let onEdit: (Note) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(note.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                Spacer()
                
                Button {
                    onEdit(note)
                } label: {
                    Text("Изменить")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
                .buttonStyle(.plain)
            }
            
            Text(note.content)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(2)
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
    }
}

struct EditNoteView: View {
    @Environment(\.dismiss) private var dismiss
    let note: Note
    let onSave: (String, String) -> Void
    
    @State private var editedTitle: String
    @State private var editedContent: String
    
    init(note: Note, onSave: @escaping (String, String) -> Void) {
        self.note = note
        self.onSave = onSave
        self._editedTitle = State(initialValue: note.title)
        self._editedContent = State(initialValue: note.content)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Заголовок", text: $editedTitle)
                    TextField("Текст заметки", text: $editedContent, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("Редактировать заметку")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Готово") {
                        onSave(editedTitle, editedContent)
                        dismiss()
                    }
                    .disabled(editedTitle.isEmpty)
                }
            }
        }
    }
}

#Preview {
    TasksViewContainer()
}
