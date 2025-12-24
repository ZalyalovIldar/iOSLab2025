//
//  CryptoRowView.swift
//  CryptoList
//
//  Created by Artur Bagautdinov on 24.12.2025.
//

import Foundation
import SwiftUI

struct CryptoRowView: View {
    
    let crypto: Crypto
    
    var body: some View {
        HStack(spacing: 12) {
            
            AsyncImage(url: URL(string: crypto.image)) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 50, height: 50)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(crypto.name)
                    .font(.headline)
                Text("\(crypto.symbol) \(crypto.currentPrice, specifier: "%.2f")$")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(LinearGradient(colors: [.blue.opacity(0.1), .cyan.opacity(0.2)], startPoint: .leading, endPoint: .trailing))
                .stroke(Color.gray, lineWidth: 1)
        )
    }
}

#Preview {
    CryptoRowView(crypto: Crypto(id: "1", name: "Bitcoin", symbol: "BTC", currentPrice: 50000.00, image: "https://coin-images.coingecko.com/coins/images/1/large/bitcoin.png?1696501400"))
}
