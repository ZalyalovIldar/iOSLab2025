//
//  PlacesStorage.swift
//  Lesson9
//
//  Created by Timur Minkhatov on 29.12.2025.
//

import Foundation

protocol PlacesStorage {
    func save(_ places: [Place])
    func load() -> [Place]
    func clear()
}

final class UserDefaultsPlacesStorage: PlacesStorage {
    
    private let userDefaults = UserDefaults.standard
    private let key = "saved_places"
    
    func save(_ places: [Place]) {
        guard let encoded = try? JSONEncoder().encode(places) else { return }
        userDefaults.set(encoded, forKey: key)
    }
    
    func load() -> [Place] {
        guard let data = userDefaults.data(forKey: key),
              let places = try? JSONDecoder().decode([Place].self, from: data) else {
            return []
        }
        return places
    }
    
    func clear() {
        userDefaults.removeObject(forKey: key)
    }
}
