import SwiftUI

@main
struct Movie_GilmutdinovApp: App {
    @State private var library = FilmLibrary()
    var body: some Scene {
        WindowGroup {
            FilmsListScreen(library: library)
        }
    }
}
