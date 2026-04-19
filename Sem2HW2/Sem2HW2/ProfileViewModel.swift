import Foundation
import Observation

struct UserProfile {
    let name: String
    let email: String
    let avatarSystemName: String
}

@Observable
final class ProfileViewModel {
    var profile: UserProfile
    var isFollowing: Bool

    init(
        profile: UserProfile = UserProfile(
            name: "Ilya Gusmanov",
            email: "example@example.com",
            avatarSystemName: "person.crop.circle.fill"
        ),
        isFollowing: Bool = false
    ) {
        self.profile = profile
        self.isFollowing = isFollowing
    }

    func toggleFollow() {
        isFollowing.toggle()
    }
}
