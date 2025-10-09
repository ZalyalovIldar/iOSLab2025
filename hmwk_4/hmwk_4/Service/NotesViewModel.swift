//
//  NotesViewModel.swift
//  hmwk_4
//
//  Created by krnklvx on 10.10.2025.
//


import Foundation
import Observation

@Observable
class NotesViewModel {
    var notes: [Note] = []
    var searchText: String = ""
    var newTitle: String = ""
    var newContent: String = ""
    
    func addNote() {
        let newNote = Note(title: newTitle, content: newContent)
        notes.append(newNote)
        saveNotes()
        newTitle = ""
        newContent = ""
    }
    
    func delete(at offsets: IndexSet) {
        notes.remove(atOffsets: offsets)
        saveNotes()
    }
    
    func deleteFilteres(at offsets: IndexSet) {
        let idToDelete = offsets.map {
            filterNotes[$0].id
        }
        notes.removeAll {
            idToDelete.contains($0.id)
        }
            saveNotes()
    }
    
    var filterNotes: [Note] {
        var result = notes
        if !searchText .trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            result = result.filter {$0.title.localizedCaseInsensitiveContains(searchText)}
        }
        
        switch sortOrder {
        case .titleAsc:
            result.sort { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending}
        case .dateDesc:
            result.sort { $0.date > $1.date }
        case .none:
            break
        }
        return result
    }
    
    func saveNotes() {
        if let data = try? JSONEncoder().encode(notes) {
            UserDefaults.standard.set(data, forKey: "notes")
        }
    }
    
    func loadNotes() {
        if let data = UserDefaults.standard.data(forKey: "notes") {
            let saved = try! JSONDecoder().decode([Note].self, from: data)
            notes = saved
        }
    }
    
    func update(note: Note, newTitle: String, newContent: String) {
        if let index = notes.firstIndex(where: { $0.id == note.id}) {
            notes[index].title = newTitle
            notes[index].content = newContent
        }
    }
    
    enum SortOrder: String, CaseIterable, Codable {
        case none, titleAsc, dateDesc
    }
    var sortOrder: SortOrder = .none
    
    init() {
        loadNotes()
    }
}
