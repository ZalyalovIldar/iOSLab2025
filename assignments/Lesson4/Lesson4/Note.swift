//
//  Task.swift
//  Lesson4
//
//  Created by Timur Minkhatov on 07.10.2025.
//

import Foundation

struct Note: Identifiable, Codable {
    let id: UUID
    var title: String
    var content: String
    
    init(id: UUID = UUID(), title: String, content: String) {
        self.id = id
        self.title = title
        self.content = content
    }
}
