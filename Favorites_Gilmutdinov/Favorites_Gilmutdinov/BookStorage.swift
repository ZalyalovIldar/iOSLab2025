import Foundation

protocol BookStorage {
    func loadBooks() -> [Book]
    func saveBooks(_ books: [Book])
}

final class UserDefaultsBookStorage: BookStorage {
    
    private let key = "favorite_books_storage_key"
    
    private let defaults = UserDefaults.standard
    
    func loadBooks() -> [Book] {
        guard let data = defaults.data(forKey: key) else {
            return []
        }
        
        do {
            let decoder = JSONDecoder()
            let items = try decoder.decode([Book].self, from: data)
            return items
        } catch {
            print("Не удалось декодировать книги:", error)
            return []
        }
    }
    
    func saveBooks(_ books: [Book]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(books)
            defaults.set(data, forKey: key)
        } catch {
            print("Не удалось закодировать книги:", error)
        }
    }
}
