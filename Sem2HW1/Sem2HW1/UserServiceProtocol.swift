import Foundation

protocol UsersServiceProtocol {
    func fetchUser(id: Int) async throws -> User
    func fetchUsers(ids: [Int]) async throws -> [User]
}
