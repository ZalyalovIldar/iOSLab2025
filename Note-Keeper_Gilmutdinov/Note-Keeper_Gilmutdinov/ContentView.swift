import SwiftUI

struct ContentView: View {
    @State private var viewModel = NotesViewModel()
    
    var body: some View {
        NavigationStack {
            NotesListView(viewModel: viewModel)
                .navigationTitle("Заметки")
        }
    }
}

#Preview {
    ContentView()
}
