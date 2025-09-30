
import Foundation

class Person: Identifiable {
    var name: String
    var spends: Int
    
    init(name: String, spends: Int = 0) {
        self.name = name
        self.spends = spends
    }
    
    static func splitter(personList: [Person]) -> Double {
        guard !personList.isEmpty else { return 0 }
        
        var sum = 0
        personList.forEach { person in
            sum += person.spends
        }
        return Double(sum) / Double(personList.count)
    }
}
