//
//  NoteKeeperApp.swift
//  hmwk_4
//
//  Created by krnklvx on 10.10.2025.
//


import SwiftUI

@main
struct NoteKeeperApp: App {
    var body: some Scene {
        WindowGroup {
            NotesListView(viewModel: NotesViewModel())
        }
    }
}
