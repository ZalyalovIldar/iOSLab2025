//
//  FavoritesStore.swift
//  FavoritesManager
//
//  Created by Artur Bagautdinov on 30.12.2025.
//

import Foundation

actor FavoritesStore {
    private let storage: FavoritesStorage

    init(storage: FavoritesStorage) {
        self.storage = storage
    }

    func load() async -> [FavoriteBook] {
        do { return try await storage.load() }
        catch {
            print("Error loading favorites: \(error)")
            return []
        }
    }

    func save(_ favorites: [FavoriteBook]) async {
        do { try await storage.save(favorites) }
        catch {
            print("Error saving favorites: \(error)")
        }
    }

    func clear() async {
        do { try await storage.clear() }
        catch {
            print("Error clearing favorites: \(error)")
        }
    }
}
