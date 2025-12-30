//
//  AddFavoriteView.swift
//  FavoritesManager
//
//  Created by Artur Bagautdinov on 30.12.2025.
//

import SwiftUI
import PhotosUI

struct AddFavoriteView: View {
    
    @Environment(\.dismiss)
    private var dismiss
    
    @Bindable var viewModel: FavoritesViewModel

    @State private var title: String = ""
    @State private var author: String = ""
    
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var coverImageData: Data?

    var canSave: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !author.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Book") {
                    TextField("Title", text: $title)
                    TextField("Author", text: $author)
                }
                
                Section("Cover") {
                    PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                        Label("Choose Photo", systemImage: "photo")
                    }

                    if let coverImageData, let uiImage = UIImage(data: coverImageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 180)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    } else {
                        HStack {
                            Spacer()
                            
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.quaternary)
                                .frame(width: 92, height: 102)
                                .overlay(
                                    Image(systemName: "book")
                                        .foregroundStyle(.secondary)
                                )
                            
                            Spacer()
                        }
                        Text("No photo selected")
                            .foregroundStyle(.secondary)
                    }

                    if coverImageData != nil {
                        Button(role: .destructive) {
                            coverImageData = nil
                            selectedPhotoItem = nil
                        } label: {
                            Label("Remove Photo", systemImage: "trash")
                        }
                    }
                }
            }
            .onChange(of: selectedPhotoItem) { _, newItem in
                guard let newItem else { return }
                Task {
                    guard let data = try? await newItem.loadTransferable(type: Data.self) else { return }
                    if let image = UIImage(data: data),
                       let jpeg = image.jpegData(compressionQuality: 0.8) {
                        coverImageData = jpeg
                    } else {
                        coverImageData = data
                    }
                }
            }

            .navigationTitle("Add Favorite")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        viewModel.add(title: title, author: author, coverImageData: coverImageData)
                        dismiss()
                    }
                    .disabled(!canSave)
                }
            }
        }
    }
}

#Preview {
    AddFavoriteView(viewModel: FavoritesViewModel())
}
