import SwiftUI

struct UsersView: View {
    let viewModel: UsersViewModel

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
            } else if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)")
            } else if viewModel.isEmpty {
                Text("No users")
            } else {
                List(viewModel.users) { user in
                    Text(user.name)
                }
            }
        }
        .task {
            await viewModel.loadUsers()
        }
    }
}
