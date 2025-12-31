import Foundation

struct Film: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var category: String
    var notes: String
    var year: Int
}

extension Film {
    static let demo: [Film] = [
        Film(
            name: "Побег из Шоушенка",
            category: "Драма",
            notes: "История о надежде и свободе.",
            year: 1994
        ),
        Film(
            name: "Тёмный рыцарь",
            category: "Боевик",
            notes: "Бэтмен против Джокера в мрачном Готэме.",
            year: 2008
        ),
        Film(
            name: "Форрест Гамп",
            category: "Драма",
            notes: "Жизнь необычного человека на фоне истории США.",
            year: 1994
        )
    ]
    
    static let draft = Film(
        name: "",
        category: "",
        notes: "",
        year: Calendar.current.component(.year, from: Date())
    )
}
