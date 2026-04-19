import Foundation
import Observation

@Observable
@MainActor
final class UsersViewModel {
    var users: [User] = []
    var isLoading = false
    var errorMessage: String?
    var isEmpty = false

    private let service: UsersService

    init(service: UsersService) {
        self.service = service
    }

    func loadUsers() async {
        isLoading = true
        errorMessage = nil
        isEmpty = false

        do {
            let loadedUsers = try await service.fetchUsers()
            users = loadedUsers
            isEmpty = loadedUsers.isEmpty
        } catch {
            users = []
            errorMessage = error.localizedDescription
            isEmpty = false
        }

        isLoading = false
    }
}
