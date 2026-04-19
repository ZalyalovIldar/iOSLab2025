import SwiftUI

struct ContentView: View {
    @State private var viewModel = ProfileViewModel()

    var body: some View {
        NavigationStack {
            ProfileControllerWrapper(
                profile: viewModel.profile,
                isFollowing: viewModel.isFollowing,
                onFollowTap: {
                    viewModel.toggleFollow()
                }
            )
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
