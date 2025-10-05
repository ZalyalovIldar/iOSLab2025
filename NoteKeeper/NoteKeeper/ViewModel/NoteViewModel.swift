//
//  NoteViewModel.swift
//  NoteKeeper
//
//  Created by Artur Bagautdinov on 05.10.2025.
//

import SwiftUI

@Observable
class NoteViewModel {
    
    var notes: [Note] = [] {
        didSet {
            saveNotesToUserDefaults()
        }
    }
    
    var newNoteName: String = ""
    var newNoteText: String = ""
    var hasAttemptedSubbmit: Bool = false
    var searchText: String = ""
    
    private let notesKey = "notesKey"
    
    init() {
        loadNotesFromUserDefaults()
    }
    
    func addNote(note: Note) {
        
        guard !newNoteName.isEmpty, !newNoteText.isEmpty else {
            hasAttemptedSubbmit = true
            return
        }
        let newNote = Note(title: newNoteName, text: newNoteText)
        notes.append(newNote)
        clearFields()
    }
    
    private func clearFields() {
        newNoteName = ""
        newNoteText = ""
        hasAttemptedSubbmit = false
    }
    
    func deleteNote(at offsets: IndexSet) {
            notes.remove(atOffsets: offsets)
    }
    
    func deleteAllNotes() {
        notes.removeAll()
    }
    
    var isFormValid: Bool {
        !newNoteName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !newNoteText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var shouldShowError: Bool {
        hasAttemptedSubbmit
    }
    
    var formErrorMessage: String? {
        
        guard shouldShowError else { return nil }
        
        if newNoteName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return "Please, enter a title for the note."
        }
        
        if newNoteText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return "Please, enter some text for the note."
        }
        return nil
    }
    
    var filteredNotes: [Note] {
        if searchText.isEmpty {
            return notes
        } else {
            return notes.filter { note in
                note.title.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var totalNotesCount: Int {
        notes.count
    }
    
    private func saveNotesToUserDefaults() {
        do {
            let encoder = JSONEncoder()
            let encodedNotes = try encoder.encode(notes)
            UserDefaults.standard.set(encodedNotes, forKey: notesKey)
        } catch {
            print("Failed to save notes to UserDefaults: \(error)")
        }
    }
    
    private func loadNotesFromUserDefaults() {
        guard let savedNotes = UserDefaults.standard.data(forKey: notesKey) else {
            return
        }
        do {
            let decoder = JSONDecoder()
            let savedNotes = try decoder.decode([Note].self, from: savedNotes)
            self.notes = savedNotes
        } catch {
            print("Failed to load notes from UserDefaults: \(error)")
            self.notes = []
        }
    }
}
