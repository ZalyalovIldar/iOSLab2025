//
//  Recipe.swift
//  IOS_LAB_HW5
//
//  Created by krnklvx on 03.12.2025.
//
import Foundation

struct Recipe: Identifiable, Hashable, Codable {
    let id: UUID
    var title: String
    var imageName: String
    var summary: String
    var category: String
}
