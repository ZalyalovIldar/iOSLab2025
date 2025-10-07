import Foundation

class Note: Identifiable {
    var id: UUID
    var title: String
    var text: String
    
    init(title: String, text: String) {
        self.title = title
        self.text = text
        self.id = UUID()
    }
}
