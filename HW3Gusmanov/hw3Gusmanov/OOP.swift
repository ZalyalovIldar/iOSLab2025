
import Foundation
import SwiftUI

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
    
    func differ(personList: [Person]) -> Double {
            let average = Person.splitter(personList: personList)
            return Double(self.spends) - average
        }
    
    func findColor(personList: [Person]) -> Color {
        let diff = differ(personList: personList)
        if diff > 0 { return .green }
        else if diff < 0 { return .red }
        else { return .white }
    }
}
