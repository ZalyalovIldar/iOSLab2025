//
//  City.swift
//  Lesson8
//
//  Created by Timur Minkhatov on 26.12.2025.
//

import Foundation

struct City: Identifiable {
    let id = UUID()
    let name: String
    let latitude: Double
    let longitude: Double
}
