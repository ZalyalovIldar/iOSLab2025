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
    
    @Environment(\.verticalSizeClass)
    private var verticalSizeClass
    
    var body: some View {
        
        NavigationStack {
            
            GeometryReader { geo in
                
                let isLandscape = verticalSizeClass == .compact
                
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
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                }
                .background(Color(.systemGroupedBackground))
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
                .padding(14)
                .frame(width: 130, height: 130)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.blue.opacity(0.12),
                                    Color.purple.opacity(0.1),
                                    Color.pink.opacity(0.08)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(color: .black.opacity(0.08), radius: 10, x: 0, y: 6)
                )
                .padding(.top, 6)

            Button {
                showConfirmationDialog = true
            } label: {
                Label("Edit Image", systemImage: "pencil")
            }
            .buttonStyle(.bordered)
            .confirmationDialog("Choose source", isPresented: $showConfirmationDialog, titleVisibility: .visible) {
                Button("Make a photo") { showCamera = true }
                Button("Choose SF Symbol") { showSymbolPicker = true }
                Button("No image") {
                    recipe.imageType = .none
                    recipe.imageName = ""
                }
            }
        }
    }
    
    private var formBlock: some View {
        
        VStack(alignment: .leading, spacing: 14) {

            Group {
                Text("Title").font(.subheadline).foregroundColor(.secondary)
                TextField("e.g. Carbonara", text: $recipe.title)
                    .textFieldStyle(.roundedBorder)
            }

            Group {
                Text("Summary").font(.subheadline).foregroundColor(.secondary)
                TextField("Short description…", text: $recipe.summary, axis: .vertical)
                    .lineLimit(3, reservesSpace: true)
                    .textFieldStyle(.roundedBorder)
            }

            Group {
                Text("Category").font(.subheadline).foregroundColor(.secondary)
                TextField("e.g. Pasta", text: $recipe.category)
                    .textFieldStyle(.roundedBorder)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.secondarySystemGroupedBackground))
                .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 6)
        )
    }
    
    private var saveButton: some View {
        
        Button {
            viewModel.add(recipe)
            dismiss()
        } label: {
            Text("Save Recipe")
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
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
