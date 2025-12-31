//
//  FavoritesViewModel.swift
//  Favorites Manager
//
//  Created by Azamat Zakirov on 31.12.2025.
//

import Foundation
import SwiftUI

@MainActor
class FavoritesViewModel: ObservableObject {
    @Published var favorites: [Favorite] = []
    @Published var filteredFavorites: [Favorite] = []
    @Published var selectedFilter: String? = nil
    @Published var sortOption: SortOption = .title
    
    enum SortOption: String, CaseIterable {
        case title = "По названию"
        case author = "По автору"
        case year = "По году"
    }
    
    private let store: FavoritesStore
    
    var availableLetters: [String] {
        let letters = Set(favorites.map { $0.firstLetter }).sorted()
        return letters
    }
    
    init(storage: FavoritesStorageProtocol = FileManagerFavoritesStorage()) {
        self.store = FavoritesStore(storage: storage)
        Task {
            await loadFavorites()
        }
    }
    
    func loadFavorites() async {
        await store.load()
        let loaded = await store.getAll()
        favorites = loaded
        applyFilters()
    }
    
    func addFavorite(title: String, author: String, year: Int?) {
        let favorite = Favorite(title: title, author: author, year: year)
        Task {
            await store.add(favorite)
            await loadFavorites()
        }
    }
    
    func removeFavorite(_ favorite: Favorite) {
        Task {
            await store.remove(favorite)
            await loadFavorites()
        }
    }
    
    func clearAll() {
        Task {
            await store.removeAll()
            await loadFavorites()
        }
    }
    
    func setFilter(_ letter: String?) {
        selectedFilter = letter
        applyFilters()
    }
    
    func setSortOption(_ option: SortOption) {
        sortOption = option
        applyFilters()
    }
    
    private func applyFilters() {
        var result = favorites
        
        if let filter = selectedFilter {
            result = result.filter { $0.firstLetter == filter }
        }
        
        switch sortOption {
        case .title:
            result.sort { $0.title < $1.title }
        case .author:
            result.sort { $0.author < $1.author }
        case .year:
            result.sort { ($0.year ?? 0) > ($1.year ?? 0) }
        }
        
        filteredFavorites = result
    }
}
