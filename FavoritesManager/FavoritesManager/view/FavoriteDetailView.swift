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

    @State private var selectedPhotoItem: PhotosPickerItem?

    private var canSave: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !author.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        Form {
            Section("Cover") {
                PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                    Label("Choose Photo", systemImage: "photo")
                }

                if let coverImageData, let uiImage = UIImage(data: coverImageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 240)
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
                            .foregroundStyle(.red)
                    }
                }
            }

            Section("Book") {
                TextField("Title", text: $title)
                TextField("Author", text: $author)
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
        .navigationTitle("Details")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    viewModel.update(
                        id: bookID,
                        title: title,
                        author: author,
                        coverImageData: coverImageData
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
        }
        .onChange(of: selectedPhotoItem) { _, newItem in
            guard let newItem else { return }
            Task {
                guard let data = try? await newItem.loadTransferable(type: Data.self) else { return }

                if let image = UIImage(data: data),
                   let jpeg = image.jpegData(compressionQuality: 0.8) {
                    await MainActor.run { coverImageData = jpeg }
                } else {
                    await MainActor.run { coverImageData = data }
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
