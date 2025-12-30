//
//  FavoritesListView.swift
//  FavoritesManager
//
//  Created by Artur Bagautdinov on 30.12.2025.
//

import SwiftUI

struct FavoritesListView: View {
    @State private var viewModel = FavoritesViewModel()

    var body: some View {
        NavigationStack {
            List {
                if viewModel.displayedFavorites.isEmpty {
                    ContentUnavailableView(
                        "No Favorites",
                        systemImage: "star.slash",
                        description: Text("Add your first favorite book or change the filter.")
                    )
                } else {
                    ForEach(viewModel.displayedFavorites) { book in
                        NavigationLink {
                            FavoriteDetailView(viewModel: viewModel, bookID: book.id)
                        } label: {
                            FavoriteRowView(book: book)
                        }
                    }
                    .onDelete(perform: viewModel.delete)
                }
            }
            .animation(.default, value: viewModel.displayedFavorites)
            .navigationTitle("Favorites")
            .toolbar {
                FavoritesToolbar(viewModel: viewModel)
            }
            .sheet(isPresented: $viewModel.isAddPresented) {
                AddFavoriteView(viewModel: viewModel)
            }
        }
    }
}

#Preview {
    FavoritesListView()
}
