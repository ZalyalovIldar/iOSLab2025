import Foundation

final class UsersService: UsersServiceProtocol {
    private let cache = UserCache()

    func fetchUser(id: Int) async throws -> User {
        if let cachedUser = await cache.user(for: id) {
            print("User \(id) loaded from cache")
            return cachedUser
        }

        print("Fetching user \(id) from network")

        let url = URL(string: "https://jsonplaceholder.typicode.com/users/\(id)")!
        let (data, _) = try await URLSession.shared.data(from: url)

        let user = try JSONDecoder().decode(User.self, from: data)
        await cache.save(user: user)

        return user
    }

    func fetchUsers(ids: [Int]) async throws -> [User] {
        try await withThrowingTaskGroup(of: User.self) { group in
            for id in ids {
                group.addTask {
                    try await self.fetchUser(id: id)
                }
            }

            var users: [User] = []

            for try await user in group {
                users.append(user)
            }

            return users.sorted { $0.id < $1.id }
        }
    }
}
