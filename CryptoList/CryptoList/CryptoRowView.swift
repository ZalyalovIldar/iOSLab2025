//
//  CryptoRowView.swift
//  CryptoList
//
//  Created by Azamat Zakirov on 29.12.2025.
//

import SwiftUI

struct CryptoRowView: View {
    let crypto: Crypto
    let priceFormatter: (Double) -> String
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: crypto.image)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                Image(systemName: "bitcoinsign.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.gray)
            }
            .frame(width: 40, height: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(crypto.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(crypto.symbol.uppercased())
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(priceFormatter(crypto.currentPrice))
                .font(.headline)
                .foregroundColor(.primary)
        }
        .padding(.vertical, 8)
    }
}

