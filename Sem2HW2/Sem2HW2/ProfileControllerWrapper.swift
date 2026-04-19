import SwiftUI

struct ProfileControllerWrapper: UIViewControllerRepresentable {
    let profile: UserProfile
    let isFollowing: Bool
    let onFollowTap: () -> Void

    func makeUIViewController(context: Context) -> ProfileViewController {
        let controller = ProfileViewController()
        controller.onFollowTap = onFollowTap
        controller.configure(profile: profile, isFollowing: isFollowing)
        return controller
    }

    func updateUIViewController(_ uiViewController: ProfileViewController, context: Context) {
        uiViewController.onFollowTap = onFollowTap
        uiViewController.configure(profile: profile, isFollowing: isFollowing)
    }
}
