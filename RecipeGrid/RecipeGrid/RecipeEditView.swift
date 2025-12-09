//
//  RecipeDetailAndEditView.swift
//  RecipeGrid
//
//  Created by Artur Bagautdinov on 03.12.2025.
//

import SwiftUI
import PhotosUI

struct RecipeEditView: View {
    
    @Binding var recipe: Recipe
    
    @State private var showConfirmationDialog = false
    @State private var showCamera = false
    @State private var showSymbolPicker = false
    @State private var takenPhoto: UIImage?
    
    @State private var originalTitle: String = ""
    @State private var originalSummary: String = ""
    @State private var originalCategory: String = ""
    
    @Environment(\.dismiss)
    private var dismiss
    
    var body: some View {
        
        GeometryReader { geo in
            
            let isLandscape = geo.size.width > geo.size.height
            
            NavigationStack {
                
                ScrollView {
                    
                    if isLandscape {
                        
                        HStack(alignment: .top, spacing: 20) {
                            
                            imageBlock
                                .frame(width: geo.size.width * 0.35)
                            
                            VStack(spacing: 20) {
                                formBlock
                                editImageButton
                            }
                            .frame(maxWidth: .infinity, alignment: .top)
                        }
                        .padding()
                    } else {
                        
                        VStack(spacing: 20) {
                            imageBlock
                            formBlock
                            editImageButton
                        }
                        .padding()
                    }
                }
                .navigationTitle("Edit Recipe")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Done") {
                            dismiss()
                        }
                    }
                }
                .background(Color(.systemGroupedBackground).ignoresSafeArea())
            }
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
        .onAppear {
            originalTitle = recipe.title
            originalSummary = recipe.summary
            originalCategory = recipe.category
        }
        .onDisappear {
            if recipe.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                recipe.title = originalTitle
            }
            if recipe.summary.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                recipe.summary = originalSummary
            }
            if recipe.category.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                recipe.category = originalCategory
            }
        }
    }
    private var imageBlock: some View {
        
        RecipeImageView(recipe: recipe)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color(.systemGray6))
                    .shadow(radius: 4)
            )
            .padding(.top)
    }
    
    private var formBlock: some View {
        
        VStack(alignment: .leading, spacing: 16) {
            Text("Edit Recipe")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.bottom, 8)
            
            VStack(alignment: .leading) {
                
                Text("Title")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                TextField("Title", text: $recipe.title)
                    .textFieldStyle(.roundedBorder)
            }
            
            VStack(alignment: .leading) {
                
                Text("Summary")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                TextField("Summary", text: $recipe.summary, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
            }
            
            VStack(alignment: .leading) {
                
                Text("Category")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                TextField("Category", text: $recipe.category)
                    .textFieldStyle(.roundedBorder)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 2)
        )
    }
    
    private var editImageButton: some View {
        
        Button("Edit Image") {
            showConfirmationDialog = true
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color(.systemBlue))
                .shadow(color: .black.opacity(0.3), radius: 6, x: 0, y: 2)
        )
        .foregroundColor(.white)
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
    RecipeEditView(recipe: .constant(Recipe(
        title: "Sample Recipe",
        imageName: "",
        summary: "A short summary.",
        category: "Main",
        imageType: .none
    )))
}
