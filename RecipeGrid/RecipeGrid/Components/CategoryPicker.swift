//
//  CategoryPicker.swift
//  RecipeGrid
//
//  Created by Ляйсан on 4/12/25.
//

import SwiftUI

struct CategoryPicker: View {
    @Binding var selectedCategory: FoodCategory
    
    var body: some View {
        Picker("", selection: $selectedCategory) {
            ForEach(FoodCategory.allCases) { category in
                Text(category.rawValue.capitalized)
                    .tag(category)
            }
        }
        .pickerStyle(.segmented)
    }
}
