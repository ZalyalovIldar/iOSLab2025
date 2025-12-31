//
//  CreateRecipeView.swift
//  RecipeGrid
//
//  Created by Ляйсан on 4/12/25.
//

import SwiftUI
import PhotosUI

struct CreateRecipeView: View {
    @Environment(\.dismiss)
    private var dismiss
    
    @Bindable var recipeViewModel: RecipeViewModel
    
    @State private var photoSelectionViewModel = PhotoSelectionViewModel()
    @State private var title: String
    @State private var summary: String
    @State private var selectedCategory: FoodCategory

    @State var imageName: String
    
    private var folderName = "recipe_images"
    let recipe: Recipe?

    var isValidInput: Bool {
        !title.isEmpty && !summary.isEmpty
    }

    init(recipeViewModel: RecipeViewModel, recipe: Recipe? = nil) {
        self.recipeViewModel = recipeViewModel
        self.recipe = recipe
        _title = .init(initialValue: recipe?.title ?? "")
        _summary = .init(initialValue: recipe?.summary ?? "")
        _selectedCategory = .init(initialValue: recipe?.category ?? FoodCategory.main)
        _imageName = .init(initialValue: recipe?.imageName ?? "\(UUID().uuidString).png")
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading) {
                        titleInput
                        summaryInput
                        categoryChoice
                        photoPicker
                        Spacer()
                    }
                    .foregroundStyle(.white)
                    .padding(.horizontal)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            CancelButton()
                        }
                        ToolbarItem(placement: .topBarTrailing) {
                            saveButton
                        }
                    }
                }
                .scrollIndicators(.hidden)
            }
            .onAppear {
                if let recipe,
                   let image = LocalFileManager.shared.getImage(imageName: recipe.imageName, folderName: folderName) {
                    photoSelectionViewModel.image = image
                }
            }
        }
    }
    
    @ViewBuilder private var titleInput: some View {
        InputTitle(title: "Title")
        TextField("", text: $title)
            .fontWeight(.medium)
            .padding()
            .glassEffect(.clear)
    }
    
    @ViewBuilder private var summaryInput: some View {
        InputTitle(title: "Summary")
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(.clear)
                .glassEffect(.clear, in: .rect(cornerRadius: 20))
            TextEditor(text: $summary)
                .scrollContentBackground(.hidden)
                .padding()
        }
    }
    
    @ViewBuilder private var categoryChoice: some View {
        InputTitle(title: "Category")
        CategoryPicker(selectedCategory: $selectedCategory)
    }
    
    private var saveButton: some View {
        Button {
            if let image = photoSelectionViewModel.image {
                LocalFileManager.shared.saveImage(image: image, imageName: imageName, folderName: folderName)
            }

            if let recipe = recipe {
                recipeViewModel.update(id: recipe.id, title: title, summary: summary, imageName: imageName, category: selectedCategory)
            } else {
                recipeViewModel.add(title: title, summary: summary, imageName: imageName, category: selectedCategory)
            }
            dismiss()
        } label: {
            Image(systemName: "checkmark")
        }
        .buttonStyle(.glassProminent)
        .tint(isValidInput ? .orange : .lightGrey)
        .disabled(!isValidInput)
    }
    
    @ViewBuilder private var photoPicker: some View {
        InputTitle(title: "Image")
        PhotosPicker(selection: $photoSelectionViewModel.photoSelection, matching: .images) {
            if let image = photoSelectionViewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            } else {
                Image("imagePlaceholder")
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
        }
        .onChange(of: photoSelectionViewModel.image) { _, newValue in
            if newValue != nil {
                imageName = "\(UUID().uuidString).png"
            }
        }
    }
}

#Preview {
    NavigationStack {
        CreateRecipeView(recipeViewModel: RecipeViewModel())
    }
}
