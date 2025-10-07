//
//  TasksViewModel.swift
//  HomeWork4
//
//  Created by Анастасия on 07.10.2025.
//
import SwiftUI
import Foundation
import Observation

@Observable
class TasksViewModel {
    
    var tasks: [Task] = []
    var searchText: String = ""
    
    init() {
        loadTasks()
    }
    
    func addTask(title: String, content: String = "") {
        let newTask = Task(title: title, content: content)
        tasks.append(newTask)
        saveTasks()
    }
    
    func removeTask(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
        saveTasks()
    }
    
    func toggle(_ task: Task) {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else { return }
        tasks[index].isDone.toggle()
        saveTasks()
    }
    
    var completedCount: Int {
        return tasks.filter { $0.isDone }.count
    }
    
    var tasksCount: Int {
        return tasks.count
    }
    
    var filteredNotes: [Task] {
        if searchText.isEmpty {
            return tasks
        } else {
            return tasks.filter { task in
                task.title.lowercased().contains(searchText.lowercased()) || task.content.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    private func saveTasks() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(tasks)
            UserDefaults.standard.set(data, forKey: "savedTasks")
            print("Задачи сохранены: \(tasks.count) задач")
        } catch {
            print("Ошибка сохранения: \(error)")
        }
    }
    
    private func loadTasks() {
        if let data = UserDefaults.standard.data(forKey: "savedTasks") {
            do {
                let decoder = JSONDecoder()
                tasks = try decoder.decode([Task].self, from: data)
                print("Задачи загружены: \(tasks.count) задач")
            } catch {
                print("Ошибка загрузки: \(error)")
                tasks = []
            }
        } else {
            tasks = []
        }
    }
}
