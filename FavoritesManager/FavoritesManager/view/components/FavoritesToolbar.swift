//
//  FavoritesToolbar.swift
//  FavoritesManager
//
//  Created by Artur Bagautdinov on 30.12.2025.
//

import SwiftUI

struct FavoritesToolbar: ToolbarContent {
    
    @Bindable var viewModel: FavoritesViewModel

    var body: some ToolbarContent {
        
        ToolbarItem(placement: .topBarLeading) {
            Menu {
                Picker("Sort", selection: $viewModel.sort) {
                    ForEach(FavoritesSort.allCases) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
            } label: {
                Label("Sort", systemImage: "arrow.up.arrow.down")
            }
        }

        ToolbarItem(placement: .topBarLeading) {
            Menu {
                Picker("Filter", selection: $viewModel.filterLetter) {
                    ForEach(viewModel.availableLetters, id: \.self) { letter in
                        Text(letter).tag(letter)
                    }
                }
            } label: {
                Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
            }
            .disabled(viewModel.favorites.isEmpty)
        }

        ToolbarItem(placement: .topBarTrailing) {
            Button {
                viewModel.isAddPresented = true
            } label: {
                Label("Add", systemImage: "plus")
            }
        }

        ToolbarItem(placement: .topBarTrailing) {
            Menu {
                Button(role: .destructive) {
                    viewModel.clearAll()
                } label: {
                    Label("Clear All", systemImage: "trash")
                }
                .disabled(viewModel.favorites.isEmpty)
            } label: {
                Image(systemName: "ellipsis.circle")
            }
        }
    }
}
