//
//  CryptoListView.swift
//  Lesson7
//
//  Created by Timur Minkhatov on 24.12.2025.
//

import SwiftUI

struct CryptoListView: View {
    
    @Bindable var viewModel: CryptoViewModel
    @State private var sortAscending = false
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    loadingView
                } else if let error = viewModel.error {
                    errorView(message: error)
                } else if viewModel.items.isEmpty {
                    emptyView
                } else {
                    contentView
                }
            }
            .navigationTitle("Cryptoсurrencies")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        sortAscending.toggle()
                        viewModel.sortByPrice(ascending: sortAscending)
                    } label: {
                        Image(systemName: sortAscending ? "arrow.up" : "arrow.down")
                    }
                }
            }
            .task {
                await viewModel.load()
            }
        }
    }
    
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
            Text("Loading cryptocurrencies")
                .foregroundStyle(.secondary)
        }
    }
    
    private func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundStyle(.red)
            
            Text(message)
                .font(.headline)
            
            Button("Retry") {
                Task {
                    await viewModel.load()
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
    
    private var emptyView: some View {
        VStack(spacing: 16) {
            Image(systemName: "tray")
                .font(.system(size: 50))
                .foregroundStyle(.secondary)
            
            Text("No cryptocurrencies found")
                .font(.headline)
                .foregroundStyle(.secondary)
        }
    }
    
    private var contentView: some View {
        List(viewModel.items) { crypto in
            CryptoRowView(crypto: crypto)
        }
        .listStyle(.plain)
    }
}
