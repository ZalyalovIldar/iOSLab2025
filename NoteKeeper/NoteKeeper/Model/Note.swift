//
//  Note.swift
//  NoteKeeper
//
//  Created by Ляйсан on 01.10.2025.
//

import Foundation

struct Note: Identifiable, Codable {
    var id: UUID
    var title: String
    var text: String
}
