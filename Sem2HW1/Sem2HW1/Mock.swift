import Foundation
@testable import Sem2HW1

enum MockError: Error, LocalizedError {
    case testError

    var errorDescription: String? {
        "Test error"
    }
}

final class MockUsersService: UsersServiceProtocol {
    var usersToReturn: [User] = []
    var errorToThrow: Error?

    func fetchUser(id: Int) async throws -> User {
        if let errorToThrow {
            throw errorToThrow
        }

        guard let user = usersToReturn.first(where: { $0.id == id }) else {
            throw MockError.testError
        }

        return user
    }

    func fetchUsers(ids: [Int]) async throws -> [User] {
        if let errorToThrow {
            throw errorToThrow
        }

        return usersToReturn.filter { ids.contains($0.id) }
    }
}
