import Foundation

class Person: Identifiable {
    let id = UUID()
    var name: String
    var spent: Double
    
    init(name: String, spent: Double) {
        self.name = name
        self.spent = spent
    }
}
