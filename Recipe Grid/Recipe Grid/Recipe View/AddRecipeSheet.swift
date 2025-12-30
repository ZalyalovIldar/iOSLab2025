//
//  AddRecipeSheet.swift
//  Recipe Grid
//
//  Created by Azamat Zakirov on 25.12.2025.
//

import SwiftUI

struct AddRecipeSheet: View {
    
    @Environment(\.dismiss)
    private var dismiss
    
    @State private var title: String = ""
    @State private var imageName: String = "balesh"
    @State private var summary: String = ""
    @State private var category: String = "Main"
    
    var recipeToEdit: Recipe? = nil
    
    var onAdd: (Recipe) -> Void
    var onEdit: ((Recipe) -> Void)? = nil
    
    private var isEditMode: Bool {
        recipeToEdit != nil
    }
    
    private var isValid: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Basics") {
                    TextField("Title *", text: $title)
                    TextField("Image Name", text: $imageName)
                    TextField("Category", text: $category)
                }
                Section("Summary") {
                    TextEditor(text: $summary)
                        .frame(height: 150)
                }
            }
            .navigationTitle(isEditMode ? "Edit Recipe" : "New Recipe")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(isEditMode ? "Save" : "Add") {
                        if let recipe = recipeToEdit {
                            let updatedRecipe = Recipe(
                                id: recipe.id,
                                title: title,
                                imageName: imageName,
                                summary: summary,
                                category: category
                            )
                            onEdit?(updatedRecipe)
                        } else {
                            onAdd(Recipe(
                                id: .init(),
                                title: title,
                                imageName: imageName,
                                summary: summary,
                                category: category
                            ))
                        }
                        dismiss()
                    }
                    .disabled(!isValid)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                if let recipe = recipeToEdit {
                    title = recipe.title
                    imageName = recipe.imageName
                    summary = recipe.summary
                    category = recipe.category
                }
            }
        }
    }
}
