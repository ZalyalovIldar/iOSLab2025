//
//  CryptoView.swift
//  CryptoCurrencies DZ7
//
//  Created by Иван Метальников on 06.01.2026.
//

import SwiftUI

struct CryptoView: View {
    @Bindable var viewModel: CryptoViewModel
    
    var body: some View {
        NavigationStack{
            content
                .navigationTitle("Cryptos")
                .task {
                    await viewModel.load()
                }
        }
    }
    
    @ViewBuilder
    var content: some View {
        switch viewModel.state {
        case .loading:
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .content:
            List(viewModel.cryptos) {crypto in
                CryptoRow(crypto: crypto)
            }
            .refreshable {
                Task{ await viewModel.load()}
            }
        case .error(let string):
            ErrorView(message: string){
                Task{await viewModel.load()}
            }
        }
    }
}

struct ErrorView: View {
    
    let message: String
    var onRetry: () -> Void
    
    var body: some View {
        VStack(spacing: 10) {
            Text(message)
                .font(.headline)
            Button("Retry", action: onRetry)
                .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, minHeight: 200)
    }
}

struct CryptoRow: View {
    let crypto: Crypto
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Text(crypto.name)
            }
            
            Text("\(crypto.currentPrice, format: .number.precision(.fractionLength(2))) $")        }
    }
}
