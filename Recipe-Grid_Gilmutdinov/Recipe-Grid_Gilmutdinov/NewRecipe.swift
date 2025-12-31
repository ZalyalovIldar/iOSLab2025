import SwiftUI

struct NewRecipeSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var category: String = ""
    @State private var pictureName: String = ""
    @State private var shortDescription: String = ""
    
    let onSave: (Recipe) -> Void
    
    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Рецепт")) {
                    TextField("Название *", text: $name)
                    TextField("Категория", text: $category)
                }
                
                Section(header: Text("Картинка")) {
                    TextField("SF Symbol (например, flame)", text: $pictureName)
                }
                
                Section(header: Text("Описание")) {
                    TextField("Краткое описание", text: $shortDescription, axis: .vertical)
                        .lineLimit(3, reservesSpace: true)
                }
                
                if !canSave {
                    Section {
                        Text("Введите название рецепта, чтобы сохранить.")
                            .foregroundColor(.red)
                            .font(.footnote)
                    }
                }
            }
            .navigationTitle("Добавить рецепт")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Закрыть") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Готово") {
                        let item = Recipe(
                            title: name,
                            imageName: pictureName,
                            summary: shortDescription,
                            category: category
                        )
                        onSave(item)
                        dismiss()
                    }
                    .disabled(!canSave)
                }
            }
        }
    }
}

#Preview {
    NewRecipeSheet { new in
        print(new)
    }
}
