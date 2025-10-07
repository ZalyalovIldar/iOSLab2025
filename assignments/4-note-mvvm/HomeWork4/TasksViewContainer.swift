//
//  TasksViewContainer.swift
//  HomeWork4
//
//  Created by Анастасия on 07.10.2025.
//

import SwiftUI

struct TasksViewContainer: View {
    @State private var viewModel = TasksViewModel()
    @State private var newTaskTitle: String = ""
    @State private var newTaskContent: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            SearchView(searchText: $viewModel.searchText)
                .padding(.horizontal)
                .padding(.bottom, 8)
            
            TaskContentView(viewModel: viewModel)
                .padding(.horizontal)
                .padding(.vertical, 4)
            
            AddTaskView(newTaskTitle: $newTaskTitle, newTaskContent: $newTaskContent) {
                viewModel.addTask(title: newTaskTitle, content: newTaskContent)
                newTaskTitle = ""
                newTaskContent = ""
            }
            .padding(.horizontal)
            
            Divider()
            TaskListView(viewModel: viewModel)
        }
        .navigationTitle("Мои заметки")
    }
}

struct AddTaskView: View {
    @Binding var newTaskTitle: String
    @Binding var newTaskContent: String
    let onAdd: () -> Void
    
    var body: some View {
        HStack {
            TextField("Новая заметка", text: $newTaskTitle)
                .textFieldStyle(.roundedBorder)
            TextField("Текст заметки", text: $newTaskContent)
                .textFieldStyle(.roundedBorder)
            Button("Добавить") {
                onAdd()
            }
            .buttonStyle(.borderedProminent)
            .disabled(newTaskTitle.isEmpty)
        }
    }
}

struct TaskListView: View {
    @Bindable var viewModel: TasksViewModel
    
    var body: some View {
        List {
            if viewModel.filteredNotes.isEmpty {
                EmptyNotesView()
            } else {
                ForEach(viewModel.filteredNotes) { task in
                    NoteRowView(task: task)
                }
                .onDelete(perform: viewModel.removeTask)
            }
        }
        .listStyle(.plain)
    }
}

struct EmptyNotesView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "note.text")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            
            Text("Заметок пока нет")
                .font(.title2)
                .foregroundColor(.gray)
            
            Text("Добавьте первую заметку!")
                .font(.body)
                .foregroundColor(.gray)
        }
        .frame(height: 200)
        .frame(maxWidth: .infinity)
    }
}

struct NoteRowView: View {
    let task: Task
    
    var body: some View {
        HStack {
            Image(systemName: "note.text")
                .foregroundColor(.blue)
                .font(.title2)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                if !task.content.isEmpty {
                    Text(task.content)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                Text("Создано: \(formatDate(task.createdDate))")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
                .font(.caption)
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
    }
        
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }
}

struct SearchView: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            TextField("Поиск заметки...", text: $searchText)
                .textFieldStyle(.roundedBorder)
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            if !searchText.isEmpty {
                Button("Очистить") {
                    searchText = ""
                }
                .foregroundColor(.blue)
                .font(.caption)
            }
        }
    }
}

struct TaskContentView: View {
    let viewModel: TasksViewModel
    
    var body: some View {
        HStack {
            Text("Всего заметок: \(viewModel.tasksCount)")
                .font(.subheadline)
                .foregroundColor(.primary)
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NavigationView {
        TasksViewContainer()
    }
}

