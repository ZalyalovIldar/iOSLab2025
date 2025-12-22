//
//  AddRecipeSheet.swift
//  Lesson5
//
//  Created by Timur Minkhatov on 07.11.2025.
//

import SwiftUI

struct AddRecipeSheet: View {
    
    @Environment(\.dismiss)
    private var dismiss
    
    @State private var title: String
    @State private var imageName: String
    @State private var summary: String
    @State private var category: String
    
    @State private var showValidationAlert = false
    @State private var validationMessage = ""
    
    var editingRecipe: Recipe?
    var onAdd: (Recipe) -> Void
    var onUpdate: ((Recipe) -> Void)?
    
    init(editingRecipe: Recipe? = nil, onAdd: @escaping (Recipe) -> Void, onUpdate: ((Recipe) -> Void)? = nil) {
        self.editingRecipe = editingRecipe
        self.onAdd = onAdd
        self.onUpdate = onUpdate
        
        _title = State(initialValue: editingRecipe?.title ?? "")
        _imageName = State(initialValue: editingRecipe?.imageName ?? "")
        _summary = State(initialValue: editingRecipe?.summary ?? "")
        _category = State(initialValue: editingRecipe?.category ?? Recipe.categories.first ?? "")
    }
    
    private var isEditing: Bool {
        editingRecipe != nil
    }
    
    private var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Basics") {
                    TextField("Title", text: $title)
                        .autocorrectionDisabled()
                    
                    TextField("Image Name", text: $imageName, prompt: Text("e.g., pasta"))
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                    
                    Picker("Category", selection: $category) {
                        ForEach(Recipe.categories, id: \.self) { cat in
                            Text(cat).tag(cat)
                        }
                    }
                }
                
                Section("Summary") {
                    TextEditor(text: $summary)
                        .frame(height: 150)
                }
                
                if !imageName.isEmpty {
                    Section("Preview") {
                        if UIImage(named: imageName) != nil {
                            HStack {
                                Spacer()
                                Image(imageName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 120)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                Spacer()
                            }
                        } else {
                            Label("Image not found", systemImage: "exclamationmark.triangle")
                                .foregroundStyle(.orange)
                        }
                    }
                }
            }
            .navigationTitle(isEditing ? "Edit Recipe" : "New Recipe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(isEditing ? "Update" : "Add") {
                        saveRecipe()
                    }
                    .disabled(!isFormValid)
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .alert("Validation Error", isPresented: $showValidationAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(validationMessage)
            }
        }
    }
    
    private func saveRecipe() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespaces)
        
        guard !trimmedTitle.isEmpty else {
            validationMessage = "Please enter a recipe title"
            showValidationAlert = true
            return
        }
        
        let recipe = Recipe(
            id: editingRecipe?.id ?? UUID(),
            title: trimmedTitle,
            imageName: imageName.trimmingCharacters(in: .whitespaces),
            summary: summary.trimmingCharacters(in: .whitespaces),
            category: category,
            dateAdded: editingRecipe?.dateAdded ?? Date()
        )
        
        if isEditing {
            onUpdate?(recipe)
        } else {
            onAdd(recipe)
        }
        
        dismiss()
    }
}
