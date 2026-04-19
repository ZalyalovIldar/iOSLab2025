import Foundation

final class RealUsersService: UsersService {
    func fetchUsers() async throws -> [User] {
        try await Task.sleep(nanoseconds: 500_000_000)

        return [
            User(id: 1, name: "Alice"),
            User(id: 2, name: "Bob"),
            User(id: 3, name: "Charlie")
        ]
    }
}
