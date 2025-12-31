//
//  FavoritesStorage.swift
//  Favorites Manager
//
//  Created by Azamat Zakirov on 31.12.2025.
//

import Foundation

protocol FavoritesStorageProtocol {
    func load() -> [Favorite]
    func save(_ favorites: [Favorite])
}

class UserDefaultsFavoritesStorage: FavoritesStorageProtocol {
    private let key = "favorites"
    
    func load() -> [Favorite] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let favorites = try? JSONDecoder().decode([Favorite].self, from: data) else {
            return []
        }
        return favorites
    }
    
    func save(_ favorites: [Favorite]) {
        guard let data = try? JSONEncoder().encode(favorites) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }
}

class FileManagerFavoritesStorage: FavoritesStorageProtocol {
    private let fileName = "favorites.json"
    
    private var fileURL: URL {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsPath.appendingPathComponent(fileName)
    }
    
    func load() -> [Favorite] {
        guard FileManager.default.fileExists(atPath: fileURL.path),
              let data = try? Data(contentsOf: fileURL),
              let favorites = try? JSONDecoder().decode([Favorite].self, from: data) else {
            return []
        }
        return favorites
    }
    
    func save(_ favorites: [Favorite]) {
        guard let data = try? JSONEncoder().encode(favorites) else { return }
        try? data.write(to: fileURL)
    }
}
