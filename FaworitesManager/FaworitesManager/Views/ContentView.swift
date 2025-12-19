//
//  ContentView.swift
//  FaworitesManager
//
//  Created by krnklvx on 17.12.2025.
//

import SwiftUI

struct ContentView: View {
    // @StateObject создаёт ViewModel один раз следит за изменениями
    @StateObject private var viewModel = CakesViewModel()
    
    // @State при изменении View перерисовывается
    @State private var newCakeName = ""
    @State private var showAddSheet = false // показывать ли окно добавления
    
    var body: some View {
        NavigationView {
            VStack {
                // если нет тортиков показываем текст
                if viewModel.availableLetters.isEmpty {
                    Text("Нет тортиков")
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    // если есть тортики показываем фильтр и сортировку
                    filterSection
                    sortSection
                }
                
                // список тортиков
                cakesList
            }
            .navigationTitle("Тортики")
            .toolbar {
                // кнопка добавления
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // при нажатии окно добавления
                        showAddSheet = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
                
                // кнопка очистки слева если есть тортики
                if !viewModel.cakes.isEmpty {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Очистить всё") {
                            // функция очистки
                            viewModel.clearAll()
                        }
                        .foregroundColor(.red)
                    }
                }
            }
            // модальное окно для добавления когда showAddSheet = true)
            .sheet(isPresented: $showAddSheet) {
                addCakeView
            }
        }
    }
    
    // фильтр по буквам
    private var filterSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                // кнопка Все показывает все тортики
                Button("Все") {
                    // nil фильтр не применён
                    viewModel.selectedLetter = nil
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                // если selectedLetter == nil синий фон иначе серый
                .background(viewModel.selectedLetter == nil ? Color.blue : Color.gray.opacity(0.2))
                // Если выбрано белый текст иначе чёрный
                .foregroundColor(viewModel.selectedLetter == nil ? .white : .primary)
                .cornerRadius(8)
                
                // создаёт кнопку для каждой буквы
                // id: \.self каждая буква уникальна
                ForEach(viewModel.availableLetters, id: \.self) { letter in
                    Button(letter) {
                        // при нажатии устанавливаем выбранную букву
                        viewModel.selectedLetter = letter
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    //эта буква выбрана синий фон иначе серый
                    .background(viewModel.selectedLetter == letter ? Color.blue : Color.gray.opacity(0.2))
                    // Если выбрана белый текст иначе чёрный
                    .foregroundColor(viewModel.selectedLetter == letter ? .white : .primary)
                    .cornerRadius(8)
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 8)
    }
    
    // кнопка сортировки
    private var sortSection: some View {
        HStack {
            Text("Сортировка:")
                .font(.caption)
                .foregroundColor(.secondary)
            
            // Кнопка направления сортировки
            Button {
                // toggle()значение на противоположное
                viewModel.sortAscending.toggle()
            } label: {
                HStack {
                    Image(systemName: viewModel.sortAscending ? "arrow.up" : "arrow.down")
                    Text(viewModel.sortAscending ? "А-Я" : "Я-А")
                }
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
            }
        }
        .padding(.horizontal)
    }
    
    // список тортиков
    private var cakesList: some View {
        // список элементов
        List {
            // перебирает отфильтрованные и отсортированные тортики
            ForEach(viewModel.filteredAndSortedCakes) { cake in
                HStack {
                    Text(cake.name)
                    Spacer()
                }
                .contentShape(Rectangle())
                // свайп вправо для удаления
                // edge: .trailing действие справа
                // allowsFullSwipe: true можно свайпнуть полностью для удаления
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    // role: .destructive красная кнопка
                    Button(role: .destructive) {
                        withAnimation {
                            viewModel.removeCake(cake)
                        }
                    } label: {
                        // иконка корзины и текст
                        Label("Удалить", systemImage: "trash")
                    }
                }
            }
        }
        .listStyle(.plain)
    }
    
    // для добавления нового тортика
    private var addCakeView: some View {
        NavigationView {
            VStack(spacing: 20) {
                TextField("Название тортика", text: $newCakeName)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                
                // кнопка добавления
                Button("Добавить") {
                    guard !newCakeName.isEmpty else { return }
                    // анимация при добавлении
                    withAnimation {
                        viewModel.addCake(name: newCakeName)
                    }
                    // очищаем поле после добавления
                    newCakeName = ""
                    // закрываем окно
                    showAddSheet = false
                }
                .buttonStyle(.borderedProminent)
                // .disabled делает кнопку неактивной если поле пустое
                .disabled(newCakeName.isEmpty)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Новый тортик")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Кнопка отмены
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Отмена") {
                        // очищаем поле
                        newCakeName = ""
                        // закрываем окно
                        showAddSheet = false
                    }
                }
            }
        }
    }
}
