//
//  ContentView.swift
//  Favorites Manager
//
//  Created by Azamat Zakirov on 31.12.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = FavoritesViewModel()
    @State private var showingAddSheet = false
    @State private var newTitle = ""
    @State private var newAuthor = ""
    @State private var newYear = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if !viewModel.availableLetters.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            FilterButton(
                                title: "Все",
                                isSelected: viewModel.selectedFilter == nil,
                                action: { viewModel.setFilter(nil) }
                            )
                            
                            ForEach(viewModel.availableLetters, id: \.self) { letter in
                                FilterButton(
                                    title: letter,
                                    isSelected: viewModel.selectedFilter == letter,
                                    action: { viewModel.setFilter(letter) }
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical, 8)
                    .background(Color(.systemGray6))
                }
                
                Picker("Сортировка", selection: $viewModel.sortOption) {
                    ForEach(FavoritesViewModel.SortOption.allCases, id: \.self) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                .onChange(of: viewModel.sortOption) { _, _ in
                    viewModel.setSortOption(viewModel.sortOption)
                }
                
                if viewModel.filteredFavorites.isEmpty {
                    Spacer()
                    VStack(spacing: 16) {
                        Image(systemName: "book.closed")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text(viewModel.selectedFilter == nil ? "Нет избранных книг" : "Нет книг на букву \(viewModel.selectedFilter ?? "")")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                } else {
                    List {
                        ForEach(viewModel.filteredFavorites) { favorite in
                            FavoriteRow(favorite: favorite)
                                .transition(.asymmetric(
                                    insertion: .scale.combined(with: .opacity),
                                    removal: .scale.combined(with: .opacity)
                                ))
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .destructive) {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                            viewModel.removeFavorite(favorite)
                                        }
                                    } label: {
                                        Label("Удалить", systemImage: "trash")
                                    }
                                }
                        }
                    }
                    .listStyle(.plain)
                    .animation(.default, value: viewModel.filteredFavorites.count)
                }
            }
            .navigationTitle("Избранные книги")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if !viewModel.favorites.isEmpty {
                        Button {
                            withAnimation {
                                viewModel.clearAll()
                            }
                        } label: {
                            Label("Очистить всё", systemImage: "trash")
                                .foregroundColor(.red)
                        }
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddSheet = true
                    } label: {
                        Label("Добавить", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddFavoriteSheet(
                    title: $newTitle,
                    author: $newAuthor,
                    year: $newYear,
                    onSave: {
                        let year = newYear.isEmpty ? nil : Int(newYear)
                        withAnimation {
                            viewModel.addFavorite(
                                title: newTitle,
                                author: newAuthor,
                                year: year
                            )
                        }
                        newTitle = ""
                        newAuthor = ""
                        newYear = ""
                        showingAddSheet = false
                    },
                    onCancel: {
                        newTitle = ""
                        newAuthor = ""
                        newYear = ""
                        showingAddSheet = false
                    }
                )
            }
        }
    }
}

struct FavoriteRow: View {
    let favorite: Favorite
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "book.fill")
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(favorite.title)
                    .font(.headline)
                
                Text(favorite.author)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                if let year = favorite.year {
                    Text("\(year) год")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

struct FilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(isSelected ? .semibold : .regular)
                .foregroundColor(isSelected ? .white : .primary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.blue : Color(.systemGray5))
                .cornerRadius(20)
        }
    }
}

struct AddFavoriteSheet: View {
    @Binding var title: String
    @Binding var author: String
    @Binding var year: String
    
    let onSave: () -> Void
    let onCancel: () -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Информация о книге")) {
                    TextField("Название", text: $title)
                    TextField("Автор", text: $author)
                    TextField("Год (необязательно)", text: $year)
                        .keyboardType(.numberPad)
                }
            }
            .navigationTitle("Новая книга")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена", action: onCancel)
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Сохранить", action: onSave)
                        .disabled(title.isEmpty || author.isEmpty)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
