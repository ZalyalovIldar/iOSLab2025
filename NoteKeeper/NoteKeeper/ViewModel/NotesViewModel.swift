//
//  NotesViewModel 2.swift
//  NoteKeeper
//
//  Created by Ляйсан on 07.10.2025.
//

import Foundation

@Observable
class NotesViewModel {
    private let userDefaultsKey = "notes"
    var notesCount: Int { notes.count }
    var sortedByNewest = true
    var sortedByTitle = false
    var searchText = ""
    var notes: [Note] = [] {
        didSet {
            save()
        }
    }
    
    var filteredNotes: [Note] {
        var notesToDisplay = notes
        
        if !searchText.isEmpty {
            notesToDisplay = notesToDisplay.filter { $0.title.localizedCaseInsensitiveContains(searchText) || $0.text.localizedCaseInsensitiveContains(searchText)}
        }
        
        if sortedByTitle {
            notesToDisplay = sortByTitle()
        }
        return notesToDisplay
    }
    
    init() {
        getNotes()
    }
    
    func getNotes() {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey),
              let notes = try? JSONDecoder().decode([Note].self, from: data)
        else { return }
        self.notes = notes
    }
    
    func addNote(_ note: Note) {
        notes.insert(note, at: 0)
    }
    
    func updateNote(id: UUID, title: String, text: String) {
        if let noteToUpdateIndex = notes.firstIndex(where: { $0.id == id }) {
            notes[noteToUpdateIndex].title = title
            notes[noteToUpdateIndex].text = text
        }
    }
    
    func save() {
        if let data = try? JSONEncoder().encode(notes) {
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        }
    }
    
    func deleteNote(_ note: Note) {
        if let noteToDeleteIndex = notes.firstIndex(where: {$0.id == note.id}) {
            notes.remove(at: noteToDeleteIndex)
        }
    }
    
    func deleteAllNotes() {
        self.notes.removeAll()
    }
    
    func sortByOldestFirst() {
        if sortedByNewest {
            notes.reverse()
        }
        sortedByNewest = false
    }
    
    func sortByNewestFirst() {
        if !sortedByNewest {
            notes.reverse()
        }
        sortedByNewest = true
    }
    
    func sortByTitle() -> [Note] {
        return notes.sorted { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }
    }
}
