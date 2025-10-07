import Foundation
import Observation
import Combine

@Observable
class NotesViewModel {
    var notes: [Note] = []
    
    func addNote(title: String, text: String) {
        let newNote = Note(title: title, text: text)
        notes.append(newNote)
    }
    
    func removeNote(_ note: Note) {
        notes.removeAll { $0.id == note.id }
    }
}
