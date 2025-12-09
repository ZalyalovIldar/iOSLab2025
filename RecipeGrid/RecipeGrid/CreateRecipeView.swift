//
//  CreateRecipeView.swift
//  RecipeGrid
//
//  Created by Artur Bagautdinov on 07.12.2025.
//

import SwiftUI

import SwiftUI

struct CreateRecipeView: View {
    
    @Bindable var viewModel: RecipesViewModel
    
    @State private var recipe = Recipe(
        title: "",
        imageName: "",
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
    
    @Environment(\.dismiss)
    private var dismiss
    
    var body: some View {
        
        NavigationStack {
            
            GeometryReader { geo in
                
                let isLandscape = geo.size.width > geo.size.height
                
                ScrollView {
                    
                    if isLandscape {
                        
                        HStack(alignment: .top, spacing: 20) {
                            
                            imageBlock
                                .frame(width: geo.size.width * 0.35)
                            
                            VStack(spacing: 20) {
                                
                                formBlock
                                saveButton
                            }
                            .frame(maxWidth: .infinity, alignment: .top)
                        }
                        .padding()
                        
                    } else {
                        
                        VStack(spacing: 20) {
                            
                            imageBlock
                            formBlock
                            saveButton
                        }
                        .padding()
                    }
                }
                .background(Color(.systemGray5).opacity(0.3))
                .navigationTitle(Text("Create Recipe"))
            }
            .fullScreenCover(isPresented: $showCamera, onDismiss: saveImage) {
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
    
    private var imageBlock: some View {
        
        VStack(spacing: 12) {
            
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
                
                Button("No image") {
                    recipe.imageType = .none
                    recipe.imageName = ""
                }
            }
        }
    }
    
    private var formBlock: some View {
        
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
                    .font(.subheadline)
                    .foregroundColor(.primary)
                
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
    }
    
    private var saveButton: some View {
        
        Button {
            withAnimation(.interpolatingSpring(stiffness: 150, damping: 15)) {
                viewModel.add(recipe)
            }
            dismiss()
        } label: {
            Text("Save Recipe")
        }
        .buttonStyle(.borderedProminent)
        .disabled(!isFormValid)
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
