//
//  Recipe.swift
//  Recipe Grid
//
//  Created by Azamat Zakirov on 25.12.2025.
//

import Foundation

struct Recipe: Identifiable, Hashable, Codable {
    let id: UUID
    let title: String
    let imageName: String
    let summary: String
    let category: String
}
