import Foundation

struct Note: Identifiable {
    let id = UUID()
    var title: String
    var text: String
}
