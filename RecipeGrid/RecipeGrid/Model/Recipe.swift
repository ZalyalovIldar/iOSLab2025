//
//  Recipe.swift
//  RecipeGrid
//
//  Created by Ляйсан on 3/12/25.
//

import Foundation

enum FoodCategory: String, CaseIterable, Identifiable, Codable, Hashable {
    case main
    case appetizer
    case salad
    case dessert
    
    var id: String { self.rawValue }
}

struct Recipe: Identifiable, Hashable, Codable {
    let id: UUID
    let title: String
    let imageName: String
    let summary: String
    let category: FoodCategory
    
    init(id: UUID = UUID(), title: String, imageName: String, summary: String, category: FoodCategory) {
        self.id = id
        self.title = title
        self.imageName = imageName
        self.summary = summary
        self.category = category
    }
    
    static let mockRecipes = [
        Recipe(
            title: "Spaghetti Carbonara",
            imageName: "carbonara",
            summary: "Cook pasta. Sauté guanciale. Mix eggs with Parmesan and combine with pasta and guanciale.",
            category: .main
        ),
        Recipe(
            title: "Greek Salad",
            imageName: "greek_salad",
            summary: "Chop tomatoes, cucumbers, and red onion. Add olives and feta cheese. Dress with olive oil and oregano.",
            category: .salad
        ),
        Recipe(
            title: "Banana Muffins",
            imageName: "banana_muffins",
            summary: "Mash bananas, mix with egg, oil, and flour. Bake for 20 minutes at 180°C (350°F).",
            category: .dessert
        ),
        Recipe(
            title: "Chicken Noodle Soup",
            imageName: "chicken_noodle_soup",
            summary: "Simmer chicken, then add carrots, celery, and noodles. Cook until noodles are tender.",
            category: .main
        ),
        Recipe(
            title: "Berry Oatmeal",
            imageName: "oatmeal_berries",
            summary: "Cook oats in milk. Top with fresh or frozen berries and a drizzle of honey.",
            category: .main
        ),
        Recipe(
            title: "Chili Con Carne",
            imageName: "chili_con_carne",
            summary: "Brown beef with onion and garlic. Add tomatoes, beans, and spices. Simmer for 30 minutes.",
            category: .main
        ),
        Recipe(
            title: "Guacamole",
            imageName: "guacamole",
            summary: "Mash avocado, then mix in diced onion, tomato, lime juice, and cilantro.",
            category: .appetizer
        ),
        Recipe(
            title: "Chocolate Lava Cake",
            imageName: "chocolate_lava_cake",
            summary: "Melt chocolate with butter, stir in eggs and a bit of flour. Bake 10–12 minutes at 200°C (400°F).",
            category: .dessert
        ),
        Recipe(
            title: "Vegetable Stir-Fry",
            imageName: "vegetable_stir_fry",
            summary: "Sauté broccoli, bell peppers, carrots, and onion in a pan. Add soy sauce and garlic.",
            category: .main
        ),
        Recipe(
            title: "Fruit Smoothie",
            imageName: "fruit_smoothie",
            summary: "Blend banana, mixed berries, yogurt, and a splash of milk until smooth.",
            category: .appetizer
        )
    ]
}
