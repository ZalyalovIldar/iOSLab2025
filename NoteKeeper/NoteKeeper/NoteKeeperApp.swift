//
//  NoteKeeperApp.swift
//  NoteKeeper
//
//  Created by Ляйсан on 01.10.2025.
//

import SwiftUI


@main
struct NoteKeeperApp: App {
    var body: some Scene {
        WindowGroup {
            NotesView(notesViewModel: NotesViewModel())
        }
    }
}
