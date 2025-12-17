//
//  ContentView.swift
//  CryptoList
//
//  Created by krnklvx on 16.12.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel = CryptoViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.isLoading { //если еще загрузка
                    ProgressView("Loading...")
                } else if let error = viewModel.error { //если есть ошибка то показываем текст ошибки к нопку перезагрзуить страницу
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundColor(.red)
                        Text("Error: \(error)")
                            .multilineTextAlignment(.center)
                            .padding()
                        Button("Retry") {
                            Task { //асинхронная хадача
                                await viewModel.load() //ждем загрузку
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                } else if viewModel.items.isEmpty { //если пустой
                    VStack(spacing: 16) {
                        Image(systemName: "list.bullet.rectangle")
                            .font(.largeTitle)
                            .foregroundColor(.secondary)
                        Text("No cryptocurrencies found") //нет даннных
                            .foregroundColor(.secondary)
                    }
                } else {
                    List {
                        Section { //секция топ5
                            TopGainersView(cryptos: viewModel.topGainers)
                        }
                        
                        Section { //секция выбора сортировки
                            Picker("Sort", selection: $viewModel.sortOption) {//что аыбрано щас
                                ForEach(SortOption.allCases, id: \.self) { option in //для любого выбора выполняем код
                                    Text(option.rawValue).tag(option) //связываем текст с вариантом enum
                                }
                            }
                            .pickerStyle(.menu)
                            .onChange(of: viewModel.sortOption) { //срабатывает при измении значения
                                viewModel.applySort() //для применения новой сортировки
                            }
                        }
                        
                        Section {
                            ForEach(viewModel.items) { crypto in
                                CryptoRowView(crypto: crypto)
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                    .refreshable { //потянуть для обновления
                        await viewModel.refresh()
                    }
                }
            }
            .navigationTitle("Crypto List")
            .task {
                await viewModel.load()
            }
        }
    }
}
