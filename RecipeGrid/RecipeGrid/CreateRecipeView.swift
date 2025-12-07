//
//  CreateRecipeView.swift
//  RecipeGrid
//
//  Created by Artur Bagautdinov on 07.12.2025.
//

import SwiftUI

struct CreateRecipeView: View {
    
    @Bindable var viewModel: RecipesViewModel
    
    @State private var recipe = Recipe(
        title: "",
        imageName: "fork.knife",
        summary: "",
        category: "",
        imageType: .symbol
    )
    
    private var isFormValid: Bool {
        !recipe.title.isEmpty &&
        !recipe.summary.isEmpty &&
        !recipe.category.isEmpty
    }

    @State private var showConfirmationDialog = false
    @State private var showCamera = false
    @State private var showSymbolPicker = false
    @State private var takenPhoto: UIImage?
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        
        NavigationStack {
            
            ScrollView {
                VStack(spacing: 20) {
                    
                    RecipeImageView(recipe: recipe)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 18)
                                .fill(Color(.systemGray6))
                                .shadow(radius: 4)
                        )
                        .padding(.top)
                    
                    Button("Edit Image") {
                        showConfirmationDialog = true
                    }
                    .buttonStyle(.bordered)
                    .confirmationDialog("Choose source", isPresented: $showConfirmationDialog, titleVisibility: .visible) {
                        
                        Button("Make a photo") {
                            showCamera = true
                        }
                
                        Button("Choose SF Symbol") {
                            showSymbolPicker = true
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        VStack(alignment: .leading) {
                            Text("Title")
                                .font(.subheadline)
                                .foregroundColor(.primary)
                            TextField("Title", text: $recipe.title)
                                .textFieldStyle(.roundedBorder)
                        }
                        
                        
                        VStack(alignment: .leading) {
                            Text("Summary")
                                .font(.subheadline)
                                .foregroundColor(.primary)
                            TextField("Summary", text: $recipe.summary, axis: .vertical)
                                .textFieldStyle(.roundedBorder)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Category")
                            
                            TextField("Category", text: $recipe.category)
                                .textFieldStyle(.roundedBorder)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 18)
                            .fill(Color(.systemGray6))
                            .shadow(radius: 4)
                        
                    )
                    
                    Button {
                        viewModel.add(recipe)
                        dismiss()
                    } label: {
                        Text("Save Recipe")
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(!isFormValid)
                }
                .padding()
                .navigationTitle(Text("Create Recipe"))
                .sheet(isPresented: $showCamera, onDismiss: saveImage) {
                    ImagePicker(image: $takenPhoto, sourceType: .camera)
                }
                .sheet(isPresented: $showSymbolPicker) {
                    SymbolPicker { symbolName in
                        recipe.imageName = symbolName
                        recipe.imageType = .symbol
                    }
                }
            }
        }
       
    }
    
    private func saveImage() {
        guard let takenPhoto else { return }
        
        do {
            try recipe.saveImage(takenPhoto)
        } catch {
            print("Image not saved: \(error)")
        }
    }
}

#Preview {
    CreateRecipeView(viewModel: RecipesViewModel())
}
