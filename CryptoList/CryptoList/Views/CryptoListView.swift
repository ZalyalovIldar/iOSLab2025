//
//  CryptoListView.swift
//  CryptoList
//
//  Created by krnklvx on 16.12.2025.
//

import SwiftUI

struct CryptoListView: View {
    let cryptos: [Crypto]
    
    var body: some View {
        ForEach(cryptos) { crypto in
            CryptoRowView(crypto: crypto)
        }
    }
}
