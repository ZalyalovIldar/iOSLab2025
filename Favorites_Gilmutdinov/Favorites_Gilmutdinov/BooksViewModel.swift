import Foundation
import Observation

@MainActor
@Observable
final class BooksViewModel {
    var books: [Book] = [] {
        didSet {
            storage.saveBooks(books)
        }
    }
    
    var newTitle: String = ""
    var newAuthor: String = ""
    var newNote: String = ""
    
    private let storage: BookStorage
    
    init(storage: BookStorage) {
        self.storage = storage
        loadFromStorage()
    }
    
    private func loadFromStorage() {
        books = storage.loadBooks()
    }
    
    func addBook() {
        let title = newTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        let author = newAuthor.trimmingCharacters(in: .whitespacesAndNewlines)
        let note = newNote.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !title.isEmpty else { return }
        
        let book = Book(title: title, author: author, note: note)
        books.append(book)
        
        newTitle = ""
        newAuthor = ""
        newNote = ""
    }
    
    func deleteBooks(at offsets: IndexSet) {
        for index in offsets {
            if books.indices.contains(index) {
                books.remove(at: index)
            }
        }
    }
}
