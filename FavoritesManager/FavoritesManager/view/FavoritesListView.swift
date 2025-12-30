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
            
            ZStack {
                
                Color.backgroundGradient
                    .ignoresSafeArea()
                
                List {
                    ForEach(viewModel.displayedFavorites) { book in
                        NavigationLink {
                            FavoriteDetailView(viewModel: viewModel, bookID: book.id)
                        } label: {
                            FavoriteRowView(book: book) {
                                viewModel.delete(id: book.id)
                            }
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .navigationTitle("Favorites")
                .animation(.default, value: viewModel.sort)
                .animation(.default, value: viewModel.filterLetter)
                .toolbar {
                    FavoritesToolbar(viewModel: viewModel)
                }
                .sheet(isPresented: $viewModel.isAddPresented) {
                    AddFavoriteView(viewModel: viewModel)
                }
                .overlay {
                    if viewModel.displayedFavorites.isEmpty {
                        ContentUnavailableView(
                            "No Favorites",
                            systemImage: "star.slash",
                            description: Text("Add your first favorite book or change the filter.")
                        )
                        .padding()
                    }
                }
            }
        }
    }
}

#Preview {
    FavoritesListView()
}
