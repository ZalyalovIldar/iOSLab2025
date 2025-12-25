//
//  CoinView.swift
//  CryptoList
//
//  Created by Ляйсан
//

import SwiftUI

struct CoinRowView: View {
    let coin: Coin
    
    var body: some View {
        HStack {
            Text("\(coin.rank)")
                .font(.caption)
                .frame(minWidth: 17)
            
            image.frame(width: 30, height: 30)
            
            Text(coin.name)
                .fontWeight(.medium)
                .lineLimit(2)
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text(coin.currentPrice.formattToDollar())
                Text(coin.priceChangePercentage24h?.formattToPercent() ?? "0.00%")
                    .foregroundStyle((coin.priceChangePercentage24h ?? 0) > 0 ? .green : .red)
            }
            .font(.subheadline)
        }
    }
    
    @ViewBuilder private var image: some View {
        if let url = URL(string: coin.image) {
            AsyncImage(url: url) { image in
                image
                    .resizable()
            } placeholder: {
                ProgressView()
            }
        }
    }
    
    private func getCahcedImage() {
        
    }
}

#Preview {
    CoinRowView(coin: Coin(id: "1", symbol: "btc", name: "Bitcoin", image: "https://coin-images.coingecko.com/coins/images/1/large/bitcoin.png?1696501400", currentPrice: 86792, marketCapRank: 1, priceChangePercentage24h: -0.29085))
        .padding(.horizontal)
}
