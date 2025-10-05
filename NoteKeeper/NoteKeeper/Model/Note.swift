//
//  Note.swift
//  NoteKeeper
//
//  Created by Artur Bagautdinov on 05.10.2025.
//

import Foundation

struct Note: Identifiable {
    let id = UUID()
    var title: String
    var text: String
}
