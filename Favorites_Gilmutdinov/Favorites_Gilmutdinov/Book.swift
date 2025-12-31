import Foundation

struct Book: Identifiable, Codable {
    let id: UUID
    var title: String
    var author: String
    var note: String
    
    init(id: UUID = UUID(), title: String, author: String, note: String = "") {
        self.id = id
        self.title = title
        self.author = author
        self.note = note
    }
}
