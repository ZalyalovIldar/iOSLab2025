//
//  guess_it_GilmutdinovApp.swift
//  guess-it_Gilmutdinov
//
//  Created by tvoryxuiny on 9/19/25.
//

import SwiftUI
import SwiftData

@main
struct guess_it_GilmutdinovApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
