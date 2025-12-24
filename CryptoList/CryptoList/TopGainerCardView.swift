//
//  TopGainerCardView.swift
//  CryptoList
//
//  Created by Artur Bagautdinov on 24.12.2025.
//

import SwiftUI

struct TopGainerCardView: View {
    
    let rank: Int
    let crypto: Crypto
    
    private var pct: Double { crypto.priceChangePercentage24h ?? 0 }
    private var pctText: String { String(format: "%@%.2f%%", pct >= 0 ? "+" : "", pct) }
    private var pctColor: Color { pct >= 0 ? .green : .red }
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            
            HStack(spacing: 10) {
                
                ZStack {
                    
                    Circle()
                        .fill(Color.secondary.opacity(0.15))
                        .frame(width: 26, height: 26)
                    
                    Text("\(rank)")
                        .font(.caption)
                        .fontWeight(.semibold)
                }
                
                AsyncImage(url: URL(string: crypto.image)) { image in
                    image.resizable().scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 26, height: 26)
                .clipShape(RoundedRectangle(cornerRadius: 6))
                
                VStack(alignment: .leading, spacing: 2) {
                    
                    Text(crypto.symbol.uppercased())
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    Text(crypto.formattedPriceUSD)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            
            HStack(spacing: 6) {
                
                Image(systemName: pct >= 0 ? "arrow.up.right" : "arrow.down.right")
                    .font(.caption2)
                    .foregroundColor(pctColor)
                
                Text(pctText)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .monospacedDigit()
                    .foregroundColor(pctColor)
            }
        }
        .padding(12)
        .frame(width: 210)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.blue.opacity(0.08))
                .stroke(Color.gray.opacity(0.35), lineWidth: 1)
        )
    }
}

#Preview {
    TopGainerCardView(rank: 1, crypto: Crypto(
        id: "1",
        name: "Bitcoin",
        symbol: "BTC",
        currentPrice: 0.0000000001,
        image: "https://coin-images.coingecko.com/coins/images/1/large/bitcoin.png?1696501400",
        priceChangePercentage24h: 2.3456))
}
