//
//  Untitled.swift
//  Lesson9
//
//  Created by Timur Minkhatov on 29.12.2025.
//

import SwiftUI

struct PlacesView: View {
    @Bindable var viewModel: PlacesViewModel
    
    @State private var showAdd = false
    @State private var showClearAlert = false
    
    private let grid = [GridItem(.adaptive(minimum: 160), spacing: 16)]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    filterBar
                    
                    bodyContent
                        .padding(.horizontal)
                }
            }
            .navigationTitle("Места, где я был")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        Button("По году") {
                            viewModel.sortOption = .year
                        }
                        Button("По названию") {
                            viewModel.sortOption = .name
                        }
                        Button("По стране") {
                            viewModel.sortOption = .country
                        }
                    } label: {
                        Label("Сортировка", systemImage: "arrow.up.arrow.down")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        Button {
                            showClearAlert = true
                        } label: {
                            Label("Очистить", systemImage: "trash")
                        }
                        .disabled(viewModel.filteredAndSortedPlaces.isEmpty)
                        
                        Button {
                            showAdd = true
                        } label: {
                            Label("Добавить", systemImage: "plus")
                        }
                    }
                }
            }
            .sheet(isPresented: $showAdd) {
                AddPlaceSheet { place in
                    viewModel.add(place)
                }
                .presentationDetents([.medium, .large])
            }
            .alert("Очистить всё?", isPresented: $showClearAlert) {
                Button("Отмена", role: .cancel) {}
                Button("Очистить", role: .destructive) {
                    viewModel.clearAll()
                }
            } message: {
                Text("Все места будут удалены")
            }
        }
    }
    
    @ViewBuilder
    private var bodyContent: some View {
        if viewModel.filteredAndSortedPlaces.isEmpty {
            EmptyStateView(
                title: "Нет мест",
                subtitle: "Добавьте первое место, нажав на кнопку +"
            )
        } else {
            LazyVGrid(columns: grid, spacing: 16) {
                ForEach(viewModel.filteredAndSortedPlaces) { place in
                    PlaceCardView(place: place)
                        .contextMenu {
                            Button(role: .destructive) {
                                viewModel.remove(place)
                            } label: {
                                Label("Удалить", systemImage: "trash")
                            }
                        }
                }
            }
        }
    }
    
    private var filterBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                FilterButton(
                    title: "Все",
                    isSelected: viewModel.filterLetter.isEmpty
                ) {
                    viewModel.filterLetter = ""
                }
                
                ForEach(Array("АБВГДЕЖЗИКЛМНОПРСТУФХЦЧШЭЮЯ"), id: \.self) { letter in
                    FilterButton(
                        title: String(letter),
                        isSelected: viewModel.filterLetter == String(letter)
                    ) {
                        viewModel.filterLetter = String(letter)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct FilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: isSelected ? .semibold : .regular))
                .foregroundStyle(isSelected ? .white : .primary)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color.blue : Color(.systemGray5))
                .clipShape(Capsule())
        }
    }
}
