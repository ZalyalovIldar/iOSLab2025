//
//  Place.swift
//  Lesson9
//
//  Created by Timur Minkhatov on 29.12.2025.
//

import Foundation

struct Place: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    let country: String
    let year: String
    let notes: String
}
