//
//  FavoritesViewModel.swift
//  FavoritesManager
//
//  Created by Artur Bagautdinov on 30.12.2025.
//

import Foundation
import SwiftUI

enum FavoritesSort: String, CaseIterable, Identifiable {
    case byDateDesc = "Newest First"
    case byDateAsc = "Oldest First"
    case byTitleAsc = "Title (A–Z)"
    case byTitleDesc = "Title (Z–A)"
    case byAuthorAsc = "Author (A–Z)"
    case byAuthorDesc = "Author (Z–A)"

    var id: String { rawValue }
}

@Observable
final class FavoritesViewModel {
    
    private let store: FavoritesStore

    var favorites: [FavoriteBook] = [] {
        didSet {
            let snapshot = favorites
            Task { await store.save(snapshot) }
        }
    }

    var sort: FavoritesSort = .byDateDesc
    var filterLetter: String = "All"

    var isAddPresented: Bool = false
    
    init() {
        let storage = FileFavoritesStorage()
        self.store = FavoritesStore(storage: storage)
        Task { await loadOnStart() }
    }
    
    private func loadOnStart() async {
        let loaded = await store.load()
        favorites = loaded
    }

    var availableLetters: [String] {
        let letters = Set(favorites.map { $0.firstLetterUppercased })
        let sorted = letters.sorted()
        return ["All"] + sorted
    }

    var displayedFavorites: [FavoriteBook] {
        var items = favorites

        if filterLetter != "All" {
            items = items.filter { $0.firstLetterUppercased == filterLetter }
        }

        switch sort {
        case .byDateDesc:
            items.sort { $0.createdAt > $1.createdAt }
        case .byDateAsc:
            items.sort { $0.createdAt < $1.createdAt }
        case .byTitleAsc:
            items.sort {
                $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending
            }
        case .byTitleDesc:
            items.sort {
                $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedDescending
            }
        case .byAuthorAsc:
            items.sort {
                $0.author.localizedCaseInsensitiveCompare($1.author) == .orderedAscending
            }
        case .byAuthorDesc:
            items.sort {
                $0.author.localizedCaseInsensitiveCompare($1.author) == .orderedDescending
            }
        }

        return items
    }

    func add(title: String, author: String, coverImageData: Data?, description: String) {
        let new = FavoriteBook(title: title, author: author, coverImageData: coverImageData, description: description)
        withAnimation(.snappy) {
            favorites.insert(new, at: 0)
        }
    }

    func delete(at offsets: IndexSet) {
        let idsToDelete = offsets.map { displayedFavorites[$0].id }
        withAnimation(.snappy) {
            favorites.removeAll { idsToDelete.contains($0.id) }
        }
    }

    func clearAll() {
        withAnimation(.snappy) {
            favorites.removeAll()
        }
        Task { await store.clear() }
    }
    
    func book(for id: UUID) -> FavoriteBook? {
        favorites.first(where: { $0.id == id })
    }

    func update(id: UUID, title: String, author: String, coverImageData: Data?, description: String) {
        guard let index = favorites.firstIndex(where: { $0.id == id }) else { return }

        var updated = favorites[index]
        updated.title = title
        updated.author = author
        updated.coverImageData = coverImageData
        updated.description = description

        withAnimation(.snappy) {
            favorites[index] = updated
        }
    }

    func delete(id: UUID) {
        withAnimation(.snappy) {
            favorites.removeAll { $0.id == id }
        }
    }
}
