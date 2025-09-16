//
//  Business_CardApp.swift
//  Business Card
//
//  Created by Ляйсан on 11.09.2025.
//

import SwiftUI

@main
struct Business_CardApp: App {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("isAccentColor") private var accentColor = "systemBlue"
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                MenuView()
            }
            .preferredColorScheme(isDarkMode ? .dark : .light)
            .tint(DataStorage.stringToColor(color: accentColor))
        }
    }
}
