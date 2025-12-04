//
//  AddRecipeSheet.swift
//  IOS_LAB_HW5
//
//  Created by krnklvx on 03.12.2025.
//
import SwiftUI

struct AddRecipeSheet: View {
    @Environment(\.dismiss) var dismiss //для закрытия модального окна
    
    @State private var title = ""
    @State private var imageName = ""
    @State private var summary = ""
    @State private var category = ""
    
    var recipe: Recipe? //Если не nil редактирование, если nil создание
    var onSave: (Recipe) -> Void //замыкание для сохранения рецепта
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Название") {
                    TextField("Введите название", text: $title)
                }
                Section("Категория") {
                    TextField("Введите категорию", text: $category)
                }
                Section("Картинка (имя файла)") {
                    TextField("Например: pasta", text: $imageName)
                }
                Section("Описание") {
                    TextField("Краткое описание", text: $summary)
                }
            }
            .navigationTitle(recipe == nil ? "Новый рецепт" : "Редактировать") //установка заголловка
            .toolbar {
                ToolbarItem(placement: .confirmationAction) { //для подтверждения справа
                    Button(recipe == nil ? "Добавить" : "Сохранить") {
                        let newRecipe = Recipe( //для редакции или сохранения
                            id: recipe?.id ?? UUID(),
                            title: title,
                            imageName: imageName,
                            summary: summary,
                            category: category
                        )
                        onSave(newRecipe) //сохранение
                        dismiss() //убираем модальное окно
                    }
                    .disabled(title.isEmpty) //дизактивная кнопка при пустом титле
                }
                ToolbarItem(placement: .cancellationAction) { //кнопка отмены справа
                    Button("Отмена") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                if let recipe = recipe { //если уже существует
                    title = recipe.title
                    imageName = recipe.imageName
                    summary = recipe.summary
                    category = recipe.category
                }
            }
        }
    }
}
