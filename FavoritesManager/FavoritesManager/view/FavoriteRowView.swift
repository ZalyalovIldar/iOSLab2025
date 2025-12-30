//
//  FavoriteRowView.swift
//  FavoritesManager
//
//  Created by Artur Bagautdinov on 30.12.2025.
//

import SwiftUI

struct FavoriteRowView: View {

    let book: FavoriteBook
    let onDelete: () -> Void

    var body: some View {
        HStack(spacing: 12) {

            coverThumb

            VStack(alignment: .leading, spacing: 4) {
                
                Text(book.title).font(.headline)

                Text(book.author)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Text(book.createdAt, style: .date)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Button(role: .destructive, action: onDelete) {
                Image(systemName: "trash")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.red)
                    .frame(width: 28, height: 28)
                    .background(.ultraThickMaterial, in: Circle())
            }
            .buttonStyle(.borderless)
            .padding()
        }
    }

    @ViewBuilder private var coverThumb: some View {
        if let data = book.coverImageData, let uiImage = UIImage(data: data) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .frame(width: 62, height: 82)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        } else {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.placeholderGradient)
                .frame(width: 62, height: 82)
                .overlay(Image(systemName: "book"))
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.secondary.opacity(0.35), lineWidth: 1)
                }
        }
    }
}

#Preview {
    FavoriteRowView(book: .init(title: "SwiftUI Essentials", author: "Artur Bagautdinov", createdAt: Date()), onDelete: {})
}
