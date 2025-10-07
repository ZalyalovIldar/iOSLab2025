//
//  Task.swift
//  HomeWork4
//
//  Created by Анастасия on 07.10.2025.
//

import Foundation

struct Task: Identifiable, Codable {
    
    let id = UUID()
    var title: String
    var content: String = ""
    var isDone: Bool = false
    let createdDate: Date = Date()
}
