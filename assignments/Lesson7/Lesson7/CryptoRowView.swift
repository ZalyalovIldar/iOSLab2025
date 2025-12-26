//
//  CryptoRowView.swift
//  Lesson7
//
//  Created by Timur Minkhatov on 24.12.2025.
//

import SwiftUI

struct CryptoRowView: View {
    
    let crypto: Crypto
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: crypto.image)) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else if phase.error != nil {
                    Image(systemName: "exclamationmark.triangle")
                        .foregroundStyle(.red)
                } else {
                    ProgressView()
                }
            }
            .frame(width: 40, height: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(crypto.name)
                    .font(.headline)
                Text(crypto.symbol.uppercased())
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(formatPrice(crypto.currentPrice))
                    .font(.headline)
                
                if let change = crypto.priceChangePercentage24h {
                    Text(formatPercentage(change))
                        .font(.subheadline)
                        .foregroundStyle(change >= 0 ? .green : .red)
                }
            }
        }
        .padding(.vertical, 4)
    }
    
    private func formatPrice(_ price: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = price < 1 ? 4 : 2
        return formatter.string(from: NSNumber(value: price)) ?? "$\(price)"
    }
    
    private func formatPercentage(_ value: Double) -> String {
        String(format: "%.2f%%", value)
    }
}
