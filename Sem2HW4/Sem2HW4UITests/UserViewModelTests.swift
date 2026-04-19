import XCTest
@testable import Sem2HW4

@MainActor
final class UsersViewModelTests: XCTestCase {

    func test_loadUsers_success_updatesUsers() async {
        let expectedUsers = [
            User(id: 1, name: "Alice"),
            User(id: 2, name: "Bob")
        ]
        let service = MockUsersService(result: .success(expectedUsers))
        let viewModel = UsersViewModel(service: service)

        await viewModel.loadUsers()

        XCTAssertEqual(viewModel.users, expectedUsers)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
    }

    func test_loadUsers_failure_setsError() async {
        let service = MockUsersService(result: .failure(MockError.failedToLoad))
        let viewModel = UsersViewModel(service: service)

        await viewModel.loadUsers()

        XCTAssertTrue(viewModel.users.isEmpty)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
    }

    func test_loadUsers_emptyResponse_setsEmptyState() async {
        let service = MockUsersService(result: .success([]))
        let viewModel = UsersViewModel(service: service)

        await viewModel.loadUsers()

        XCTAssertEqual(viewModel.users, [])
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertTrue(viewModel.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
    }
}
