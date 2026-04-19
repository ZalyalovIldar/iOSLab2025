import Foundation

struct User: Codable, Identifiable {
    let id: Int
    let name: String
    let username: String
    let email: String
}
