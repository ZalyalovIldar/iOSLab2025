//
//  CryptoListView.swift
//  CryptoList
//
//  Created by Azamat Zakirov on 29.12.2025.
//

import SwiftUI

struct CryptoListView: View {
    @Bindable var viewModel: CryptoViewModel
    
    var body: some View {
        List {
            Section("Top Gainers") {
                ForEach(viewModel.topGainers) { crypto in
                    CryptoRowView(
                        crypto: crypto,
                        priceFormatter: viewModel.formatPrice
                    )
                }
            }
            
            Section("All Cryptocurrencies") {
                ForEach(viewModel.items) { crypto in
                    CryptoRowView(
                        crypto: crypto,
                        priceFormatter: viewModel.formatPrice
                    )
                }
            }
        }
        .refreshable {
            await viewModel.load(forceRefresh: true)
        }
    }
}
