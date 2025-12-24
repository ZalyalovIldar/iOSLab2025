//
//  ContentView.swift
//  CryptoList
//
//  Created by Artur Bagautdinov on 22.12.2025.
//

import SwiftUI

struct CryptosListView: View {
    
    @Bindable var viewModel: CryptosViewModel
    
    @State private var showTopGainers = true
    
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
                
                LazyVStack(alignment: .leading, spacing: 14) {
                    
                    if !viewModel.topGainers.isEmpty {
                        HStack {
                            
                            Text("Top Gainers")
                                .font(.headline)
                            
                            Spacer()
                            
                            Button {
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
                                    showTopGainers.toggle()
                                }
                            } label: {
                                Image(systemName: showTopGainers ? "chevron.up" : "chevron.down")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(.horizontal)
                        
                        if showTopGainers {
                            ScrollView(.horizontal, showsIndicators: false) {
                                
                                LazyHStack(spacing: 12) {
                                    
                                    ForEach(Array(viewModel.topGainers.enumerated()), id: \.element.id) { index, crypto in
                                        TopGainerCardView(rank: index + 1, crypto: crypto)
                                    }
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 4)
                            }
                            .transition(.scale(scale: 0.95, anchor: .top).combined(with: .opacity))
                        }
                    }
                    
                    Text("All")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    LazyVStack(alignment: .leading, spacing: 10) {
                        
                        ForEach(viewModel.sortedCryptos) { crypto in
                            CryptoRowView(crypto: crypto)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .refreshable {
                await viewModel.load(forceReload: true)
            }
            
        case .error(let message):
            ErrorView(message: message) {
                Task { await viewModel.load(forceReload: true) }
            }
        }
    }
}

#Preview {
    CryptosListView(viewModel: CryptosViewModel(service: RealCryptoService()))
}
