import SwiftUI

@main
struct Sem2HW4App: App {
    var body: some Scene {
        WindowGroup {
            UsersView(
                viewModel: UsersViewModel(service: RealUsersService())
            )
        }
    }
}
