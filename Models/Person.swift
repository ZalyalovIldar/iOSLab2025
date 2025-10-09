//
//  Person.swift
//  OOPSwift
//
//  Created by krnklvx on 05.10.2025.
//

import Foundation

struct Person: Identifiable, Codable {
    let id = UUID()
    var name: String
    var amount: Double
}

