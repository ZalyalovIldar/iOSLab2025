//
//  FavoritesAppApp.swift
//  FavoritesApp
//
//  Created by Ляйсан

import SwiftUI

@main
struct FavoritesAppApp: App {
    @State var songsViewModel = SongsViewModel(fileManager: LocalFileManager())
    
    var body: some Scene {
        WindowGroup {
            SongsView(songsViewModel: songsViewModel)
                .colorScheme(.dark)
        }
    }
}
