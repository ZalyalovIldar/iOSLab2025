//
//  TasksViewModel.swift
//  Lesson4
//
//  Created by Timur Minkhatov on 07.10.2025.
//

import SwiftUI
import Foundation
import Observation

@Observable
final class TasksViewModel {
    
    var notes: [Note] = [] {
        didSet {
            saveNotes()
        }
    }
    
    var searchText: String = ""
    var sortOption: SortOption = .byDateNewestFirst
    
    enum SortOption: CaseIterable {
        case byDateNewestFirst
        case byDateOldestFirst
        case byTitleAZ
        case byTitleZA
        
        var title: String {
            switch self {
            case .byDateNewestFirst: return "По дате (сначала новые)"
            case .byDateOldestFirst: return "По дате (сначала старые)"
            case .byTitleAZ: return "По алфавиту (А-Я)"
            case .byTitleZA: return "По алфавиту (Я-А)"
            }
        }
    }
    
    var filteredNotes: [Note] {
        let filtered = searchText.isEmpty ? notes : notes.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        
        switch sortOption {
        case .byDateNewestFirst:
            return filtered.sorted { $0.createdAt > $1.createdAt }
        case .byDateOldestFirst:
            return filtered.sorted { $0.createdAt < $1.createdAt }
        case .byTitleAZ:
            return filtered.sorted { $0.title < $1.title }
        case .byTitleZA:
            return filtered.sorted { $0.title > $1.title }
        }
    }
    
    var notesCount: Int {
        notes.count
    }
    
    init() {
        loadNotes()
    }
    
    func addNote(title: String, content: String) {
        let newNote = Note(title: title, content: content, createdAt: Date())
        notes.append(newNote)
    }
    
    func removeNote(at offsets: IndexSet) {
        notes.remove(atOffsets: offsets)
    }
    
    func chooseSort(_ option: SortOption) {
        sortOption = option
    }
    
    func updateNote(id: UUID, newTitle: String, newContent: String) {
        if let index = notes.firstIndex(where: { $0.id == id }) {
            notes[index].title = newTitle
            notes[index].content = newContent
        }
    }
    
    private func saveNotes() {
        do {
            let encodedNotes = try JSONEncoder().encode(notes)
            UserDefaults.standard.set(encodedNotes, forKey: "savedNotes")
        } catch {
            print("Ошибка сохранения заметок: \(error)")
        }
    }
    
    private func loadNotes() {
        if let savedData = UserDefaults.standard.data(forKey: "savedNotes") {
            do {
                let decodedNotes = try JSONDecoder().decode([Note].self, from: savedData)
                notes = decodedNotes
            } catch {
                print("Ошибка загрузки заметок: \(error)")
            }
        }
    }
}
