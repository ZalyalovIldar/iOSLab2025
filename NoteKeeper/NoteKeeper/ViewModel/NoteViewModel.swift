//
//  NoteViewModel.swift
//  NoteKeeper
//
//  Created by Artur Bagautdinov on 05.10.2025.
//

import SwiftUI

@Observable
class NoteViewModel {
    
    var notes: [Note] = []
    var newNoteName: String = ""
    var newNoteText: String = ""
    var hasAttemptedSubbmit: Bool = false
    
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
    
    var totalNotesCount: Int {
        notes.count
    }
}
