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
    
    var filteredNotes: [Note] {
        if searchText.isEmpty {
            return notes
        } else {
            return notes.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var notesCount: Int {
        notes.count
    }
    
    init() {
        loadNotes()
    }
    
    func addNote(title: String, content: String) {
        let newNote = Note(title: title, content: content)
        notes.append(newNote)
    }
    
    func removeNote(at offsets: IndexSet) {
        notes.remove(atOffsets: offsets)
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
