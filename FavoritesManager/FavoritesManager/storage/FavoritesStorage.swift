//
//  FavoritesStorage.swift
//  FavoritesManager
//
//  Created by Artur Bagautdinov on 30.12.2025.
//

import Foundation

protocol FavoritesStorage {
    func load() throws -> [FavoriteBook]
    func save(_ favorites: [FavoriteBook]) throws
    func clear() throws
}

final class FileFavoritesStorage: FavoritesStorage {
    
    private let fileURL: URL
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    init(filename: String = "favorites.json") {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        self.fileURL = dir.appendingPathComponent(filename)

        let encoder = JSONEncoder()
        self.encoder = encoder

        let decoder = JSONDecoder()
        self.decoder = decoder
    }

    func load() throws -> [FavoriteBook] {
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return [] }
        let data = try Data(contentsOf: fileURL)
        return try decoder.decode([FavoriteBook].self, from: data)
    }

    func save(_ favorites: [FavoriteBook]) throws {
        let data = try encoder.encode(favorites)
        try data.write(to: fileURL, options: [.atomic])
    }

    func clear() throws {
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return }
        try FileManager.default.removeItem(at: fileURL)
    }
}
