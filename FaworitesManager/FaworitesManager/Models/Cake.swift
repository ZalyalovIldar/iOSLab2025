//
//  Cake.swift
//  FaworitesManager
//
//  Created by krnklvx on 17.12.2025.
//

import Foundation

struct Cake: Codable, Identifiable {
    let id: UUID
    var name: String
    
    init(id: UUID = UUID(), name: String) {
        self.id = id
        self.name = name
    }
}
