import Foundation

actor UserCache {
    private var storahe: [Int: User] = [:]
    
    func user(for id: Int) -> User? {
        storahe[id]
    }
    
    func save(user: User) {
        storahe[user.id] = user
    }
}
