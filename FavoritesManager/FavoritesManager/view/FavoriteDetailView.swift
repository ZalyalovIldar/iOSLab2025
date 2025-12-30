//
//  FavoriteDetailView.swift
//  FavoritesManager
//
//  Created by Artur Bagautdinov on 30.12.2025.
//

import SwiftUI
import PhotosUI

struct FavoriteDetailView: View {
    
    @Environment(\.dismiss)
    private var dismiss

    @Bindable var viewModel: FavoritesViewModel
    let bookID: UUID

    @State private var title: String = ""
    @State private var author: String = ""
    @State private var coverImageData: Data?
    @State private var description: String = ""

    @State private var selectedPhotoItem: PhotosPickerItem?

    private var canSave: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !author.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        
        ZStack {
            
            Color.backgroundGradient
                .ignoresSafeArea()
            
            Form {
                Section("Cover") {
                    PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                        Label("Choose Photo", systemImage: "photo")
                    }
                    
                    if let coverImageData, let uiImage = UIImage(data: coverImageData) {
                        HStack {
                            Spacer()
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 240)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            Spacer()
                        }
                    } else {
                        HStack {
                            
                            Spacer()
                            
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.secondary, lineWidth: 1)
                                .fill(Color.placeholderGradient)
                                .frame(width: 92, height: 102)
                                .overlay(
                                    Image(systemName: "book")
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
                                .foregroundStyle(.red)
                        }
                    }
                }
                
                Section("Book") {
                    TextField("Title", text: $title)
                    TextField("Author", text: $author)
                }
                
                Section("Details") {
                    TextField(
                        "Description",
                        text: $description,
                        axis: .vertical
                    )
                    .lineLimit(3...8)
                }
                
                Section {
                    Button(role: .destructive) {
                        viewModel.delete(id: bookID)
                        dismiss()
                    } label: {
                        Label("Delete Book", systemImage: "trash")
                            .foregroundStyle(.red)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .navigationTitle("Details")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        viewModel.update(
                            id: bookID,
                            title: title,
                            author: author,
                            coverImageData: coverImageData,
                            description: description
                        )
                        dismiss()
                    }
                    .disabled(!canSave)
                }
            }
            .onAppear {
                guard let book = viewModel.book(for: bookID) else { return }
                title = book.title
                author = book.author
                coverImageData = book.coverImageData
                description = book.description
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
        }
    }
}

#Preview {
    let vm = FavoritesViewModel()
    let book = FavoriteBook(title: "Sample Book", author: "Sample Author", coverImageData: nil)
    vm.favorites = [book]
    return FavoriteDetailView(viewModel: vm, bookID: book.id)
}
