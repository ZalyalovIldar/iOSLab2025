//
//  FavoritesStore.swift
//  Favorites Manager
//
//  Created by Azamat Zakirov on 31.12.2025.
//

import Foundation

actor FavoritesStore {
    private var favorites: [Favorite] = []
    private let storage: FavoritesStorageProtocol
    
    init(storage: FavoritesStorageProtocol) {
        self.storage = storage
    }
    
    func load() async {
        favorites = storage.load()
    }
    
    func getAll() async -> [Favorite] {
        return favorites
    }
    
    func add(_ favorite: Favorite) async {
        favorites.append(favorite)
        storage.save(favorites)
    }
    
    func remove(_ favorite: Favorite) async {
        favorites.removeAll { $0.id == favorite.id }
        storage.save(favorites)
    }
    
    func removeAll() async {
        favorites.removeAll()
        storage.save(favorites)
    }
    
    func update(_ favorites: [Favorite]) async {
        self.favorites = favorites
        storage.save(favorites)
    }
}
