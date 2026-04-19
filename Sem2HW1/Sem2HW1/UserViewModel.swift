import Foundation
import Observation

@MainActor
@Observable
final class UsersViewModel {
    var users: [User] = []
    var isLoading = false
    var errorMessage: String?

    private let service: UsersServiceProtocol

    init(service: UsersServiceProtocol = UsersService()) {
        self.service = service
    }

    func loadUsers(ids: [Int] = [1, 2, 3]) {
        Task {
            isLoading = true
            errorMessage = nil

            do {
                users = try await service.fetchUsers(ids: ids)
            } catch {
                users = []
                errorMessage = error.localizedDescription
            }

            isLoading = false
        }
    }

    func loadSingleUserTwice() {
        Task {
            do {
                let first = try await service.fetchUser(id: 1)
                print("First load: \(first.name)")

                let second = try await service.fetchUser(id: 1)
                print("Second load: \(second.name)")
            } catch {
                print("Error: \(error)")
            }
        }
    }
}
