import Foundation

struct Movie: Identifiable, Codable, Hashable {
    var id = UUID()
    var title: String
    var genre: String
    var description: String
    var releaseYear: Int
}

