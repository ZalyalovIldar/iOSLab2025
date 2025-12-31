import Foundation

struct Recipe: Identifiable, Hashable {
    let id: UUID
    let title: String
    let imageName: String
    let summary: String
    let category: String
    
    init(
        id: UUID = UUID(),
        title: String,
        imageName: String,
        summary: String,
        category: String
    ) {
        self.id = id
        self.title = title
        self.imageName = imageName
        self.summary = summary
        self.category = category
    }
}

extension Recipe {
    static let demo: [Recipe] = [
        Recipe(
            title: "Борщ по-домашнему",
            imageName: "drop",
            summary: "Сытный свекольный суп со сметаной и чесноком.",
            category: "Супы"
        ),
        Recipe(
            title: "Панкейки на завтрак",
            imageName: "circle.grid.3x3",
            summary: "Пышные панкейки с мёдом и ягодами.",
            category: "Завтрак"
        ),
        Recipe(
            title: "Гуакамоле",
            imageName: "avocado",
            summary: "Паста из авокадо, лайма и кинзы.",
            category: "Закуски"
        )
    ]
}
