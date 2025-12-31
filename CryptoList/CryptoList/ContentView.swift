//
//  ContentView.swift
//  CryptoList
//
//  Created by Azamat Zakirov on 29.12.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel = CryptoViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    loadingView
                } else if let error = viewModel.error {
                    errorView(error)
                } else if viewModel.items.isEmpty {
                    emptyView
                } else {
                    CryptoListView(viewModel: viewModel)
                }
            }
            .navigationTitle("Cryptocurrencies")
            .task {
                await viewModel.load()
            }
        }
    }
    
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
            Text("Loading cryptocurrencies...")
                .foregroundColor(.secondary)
        }
    }
    
    private func errorView(_ error: Error) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundColor(.red)
            Text("Error loading data")
                .font(.headline)
            Text(error.localizedDescription)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
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
            Image(systemName: "bitcoinsign.circle")
                .font(.largeTitle)
                .foregroundColor(.gray)
            Text("No cryptocurrencies found")
                .font(.headline)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    ContentView()
}
