//
//  ContentView.swift
//  CryptoList
//
//  Created by Artur Bagautdinov on 22.12.2025.
//

import SwiftUI

struct CryptosListView: View {
    
    @Bindable var viewModel: CryptosViewModel
    
    var body: some View {
        
        NavigationStack {
            content
                .navigationTitle("Cryptos")
                .task {
                    await viewModel.load()
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu {
                            Picker("Sort", selection: $viewModel.sortOption) {
                                ForEach(CryptosViewModel.SortOption.allCases) { option in
                                    Text(option.title)
                                        .tag(option)
                                }
                            }
                        } label: {
                            Image(systemName: "arrow.up.arrow.down")
                        }
                    }
                }
        }
        
    }
    
    @ViewBuilder private var content: some View {
        switch viewModel.state {
            case .loading:
            ProgressView()
                .frame(maxWidth: .infinity, minHeight: 200)
        case .empty:
            EmptyStateView(title: "No cryptoconcurrencies", subtitle: "Try reloading or check the API") {
                Task { await viewModel.load(forceReload: true) }
            }
        case .content:
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 10) {
                    ForEach(viewModel.sortedCryptos) { crypto in
                        CryptoRowView(crypto: crypto)
                    }
                }
                .padding()
            }
            .refreshable {
                Task { await viewModel.load(forceReload: true) }
            }
            
        case .error(let message):
            ErrorView(message: message) {
                Task { await viewModel.load(forceReload: true) }
            }
        }
    }
}

#Preview {
    CryptosListView(viewModel: CryptosViewModel(service: realCryptoService()))
}
