import SwiftUI

struct ContentView: View {
    @State private var viewModel = UsersViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Button("Load users with TaskGroup") {
                    viewModel.loadUsers()
                }

                Button("Load one user twice") {
                    viewModel.loadSingleUserTwice()
                }

                if viewModel.isLoading {
                    ProgressView()
                }

                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundStyle(.red)
                }

                if viewModel.users.isEmpty && !viewModel.isLoading && viewModel.errorMessage == nil {
                    ContentUnavailableView("No users", systemImage: "person.slash")
                } else {
                    List(viewModel.users) { user in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(user.name)
                                .font(.headline)

                            Text(user.email)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .padding()
            .navigationTitle("Users")
        }
    }
}

#Preview {
    ContentView()
}
