//
//  Music.swift
//  FavoritesApp
//
//  Created by Ляйсан

import Foundation

struct Song: Identifiable, Codable {
    let id: String
    var name: String
    var artist: String
    
    init(id: String = UUID().uuidString, name: String, artist: String) {
        self.id = id
        self.name = name
        self.artist = artist
    }
}
