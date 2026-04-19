import Foundation

enum MockError: Error {
    case failedToLoad
}

final class MockUsersService: UsersService {
    var result: Result<[User], Error>

    init(result: Result<[User], Error>) {
        self.result = result
    }

    func fetchUsers() async throws -> [User] {
        try result.get()
    }
}
