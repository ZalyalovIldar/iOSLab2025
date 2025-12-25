//
//  CryptoListView.swift
//  CryptoList
//
//  Created by Ляйсан
//

import SwiftUI

enum Section: String, Identifiable, CaseIterable {
    case coins, topGainers
    
    var id: String { self.rawValue }
    var title: String {
        switch self {
        case .coins: return "All Coins"
        case .topGainers: return "Top Gainers"
        }
    }
}

struct CryptoListView: View {
    @Bindable var coinViewModel: CoinViewModel
    
    @State private var selectedSection: Section = .coins
    
    init(coinViewModel: CoinViewModel) {
        self.coinViewModel = coinViewModel
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background.ignoresSafeArea()
                
                VStack(alignment: .leading) {
                    title.padding(.horizontal)
                    sectionPicker.padding()
                    
                    if coinViewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        list
                    }
                }
            }
            .alert(coinViewModel.alert?.title ?? "Error",
                   isPresented: alertBinding,
                   actions: {
                        Button("Retry") {
                            coinViewModel.getCoins()
                        }
                    }, message: {
                        if let message = coinViewModel.alert?.message {
                            Text(message)
                        }
            })
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    contextMenu
                }
            }
        }
    }
    
    @ViewBuilder private var title: some View {
        Text("Crypto")
            .font(.largeTitle.bold())
        Text("Live Prices")
            .font(.subheadline)
            .foregroundStyle(.gray)
    }
    
    private var sectionPicker: some View {
        Picker("", selection: $selectedSection) {
            ForEach(Section.allCases) { section in
                Text(section.title)
                    .tag(section)
            }
        }
        .pickerStyle(.segmented)
    }
    
    private var list: some View {
        List {
            ForEach(selectedSection == .coins ? coinViewModel.sortedCoins : coinViewModel.topGainersCoins) { coin in
                CoinRowView(coin: coin)
            }
        }
        .scrollContentBackground(.hidden)
        .scrollIndicators(.hidden)
        .padding(.top, -10)
        .refreshable {
            coinViewModel.getCoins()
        }
    }
    
    private var contextMenu: some View {
        Menu {
            Menu {
                Button {
                    coinViewModel.isSortedByPrice.toggle()
                } label: {
                    sortByPriceLabel
                }
            } label: {
                sortLabel
            }
        } label: {
            Image(systemName: "ellipsis")
        }
    }
    
    private var sortByPriceLabel: some View {
        HStack {
            Image(systemName: coinViewModel.isSortedByPrice ? "checkmark" : "")
            Text("Price")
        }
    }
    
    private var sortLabel: some View {
        HStack {
            Image(systemName: "arrow.up.arrow.down")
            Text("Sort By")
            Spacer()
            Image(systemName: "chevron.right")
        }
    }
    
    private var alertBinding: Binding<Bool> {
        Binding {
            coinViewModel.alert != nil
        } set: { newValue in
            if !newValue {
                coinViewModel.alert = nil
            }
        }
    }
}

#Preview {
    CryptoListView(coinViewModel: CoinViewModel(service: CoinsServiceImplementation()))
}
