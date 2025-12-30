//
//  PlacesViewModel.swift
//  Lesson9
//
//  Created by Timur Minkhatov on 29.12.2025.
//

import Foundation

@Observable
final class PlacesViewModel {
    
    enum SortOption {
        case name
        case year
        case country
    }
    
    private var places: [Place] = []
    var sortOption: SortOption = .year
    var filterLetter: String = ""
    
    private let storage: PlacesStorage
    
    var filteredAndSortedPlaces: [Place] {
        var result = places
        
        if !filterLetter.isEmpty {
            result = result.filter { $0.name.uppercased().hasPrefix(filterLetter.uppercased()) }
        }
        
        switch sortOption {
        case .name:
            result.sort { $0.name < $1.name }
        case .year:
            result.sort { $0.year > $1.year }
        case .country:
            result.sort { $0.country < $1.country }
        }
        
        return result
    }
    
    init(storage: PlacesStorage) {
        self.storage = storage
        loadPlaces()
    }
    
    func loadPlaces() {
        places = storage.load()
    }
    
    func add(_ place: Place) {
        places.insert(place, at: 0)
        storage.save(places)
    }
    
    func remove(_ place: Place) {
        guard let index = places.firstIndex(of: place) else { return }
        places.remove(at: index)
        storage.save(places)
    }
    
    func clearAll() {
        places.removeAll()
        storage.clear()
    }
}
