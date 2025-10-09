//
//  DataManager.swift
//  hmwk_3
//
//  Created by krnklvx on 10.10.2025.
//


import Foundation

class DataManager: ObservableObject {
    @Published var persons: [Person] = []
    
    func saveToUserDefaults() {
        if let encoded = try? JSONEncoder().encode(persons) {
            UserDefaults.standard.set(encoded, forKey: "savedPersons")
        }
    }
    
    func loadFromUserDefaults() {
        if let savedData = UserDefaults.standard.data(forKey: "savedPersons"),
           let decoded = try? JSONDecoder().decode([Person].self, from: savedData) {
            persons = decoded
        }
    }
    
    func exportToJSON() -> String? {
        if let jsonData = try? JSONEncoder().encode(persons),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            return jsonString
        }
        return nil
    }
    
    func importFromJSON(_ jsonText: String) throws -> [Person] {
        guard let jsonData = jsonText.data(using: .utf8) else {
            throw NSError(domain: "Invalid JSON format", code: 0)
        }
        return try JSONDecoder().decode([Person].self, from: jsonData)
    }
    
    var total: Double {
        persons.reduce(0) { $0 + $1.amount }
    }
    
    var average: Double {
        guard !persons.isEmpty else { return 0 }
        return total / Double(persons.count)
    }
    
    func balanceMoney(for person: Person) -> Double {
        person.amount - average
    }
}
