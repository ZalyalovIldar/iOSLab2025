//
//  Note.swift
//  NoteKeeper
//
//  Created by krnklvx on 06.10.2025.
//

import Foundation

struct Note: Identifiable, Codable, Hashable {
    let id: UUID
    var title: String
    var content: String
    var date: Date
    
    init(title: String, content: String) {
        self.id = UUID()
        self.title = title
        self.content = content
        self.date = Date()
    }
}
