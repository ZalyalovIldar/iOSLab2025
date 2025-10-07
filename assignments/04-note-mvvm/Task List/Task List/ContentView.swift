//
//  ContentView.swift
//  Task List
//
//  Created by Иван Метальников on 06.10.2025.
//

import SwiftUI

struct ContentView: View {
    @State var inputTaskField: String = ""
    @State var taskRepository: TaskRepository = TaskRepository()
    @State var searchTextField: String = ""
    
    var body: some View {
        VStack {
            AddView(inputTaskField: $inputTaskField, taskRepository: taskRepository)
            SearchBar(text: $searchTextField)
            TaskListView(taskRepository: taskRepository, searchTextField: $searchTextField)
        }
        .padding()
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        TextField("Поиск", text: $text)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(8.0)
    }
}

struct AddView: View {
    @Binding var inputTaskField: String
    @Bindable var taskRepository: TaskRepository
    
    var body: some View {
        HStack {
            TextField("Введите задачу: ", text: $inputTaskField)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8.0)
            Spacer()
            Button(action:{
                taskRepository.addTask(inputTaskField)
                inputTaskField = ""
            })
            {
                Image(systemName: "plus")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Color.blue)
                    .clipShape(Circle())
            }
        }
    }
}

struct TaskListView: View {
    @Bindable var taskRepository: TaskRepository
    @Binding var searchTextField: String
    
    var count: Int {
        if searchTextField.isEmpty{
            return taskRepository.tasks.count
        }
        else {
            return taskRepository.tasks.filter { $0.title.localizedCaseInsensitiveContains(searchTextField) }.count
        }
    }

    var body: some View {
        VStack {
            Text("Всего заметок: \(count)")
                .font(.title)
            List {
                ForEach($taskRepository.tasks) { $task in
                    if searchTextField.isEmpty {
                        TaskRow(task: $task)
                    }
                    else if task.title.localizedCaseInsensitiveContains(searchTextField){
                        TaskRow(task: $task)
                    }
                }
                .onDelete { indexSet in
                    taskRepository.removeTask(at: indexSet)
                }
            }
        }
    }
}
    
    
struct TaskRow: View {
    @Binding var task : Task
    
    var body: some View {
        HStack {
            Text(task.title)
        }
    }
}

#Preview {
    ContentView()
}
