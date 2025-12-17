//
//  TopGainersView.swift
//  CryptoList
//
//  Created by krnklvx on 16.12.2025.
//

import SwiftUI

struct TopGainersView: View {
    let cryptos: [Crypto]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Top Gainers")
                .font(.title2)
                .fontWeight(.bold)
            //горизонтальная прокрутка скрыть полосу прокрутки
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(cryptos) { crypto in
                        VStack(spacing: 8) {
                            AsyncImage(url: URL(string: crypto.image)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            } placeholder: {
                                ProgressView() 
                            }
                            .frame(width: 60, height: 60)
                            
                            Text(crypto.symbol.uppercased())
                                .font(.caption)
                                .fontWeight(.semibold)
                            
                            Text(formatPrice(crypto.currentPrice))
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                }
            }
        }
        .padding(.vertical, 8)
    }
    
    private func formatPrice(_ price: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: price)) ?? "$0.00"
    }
}
