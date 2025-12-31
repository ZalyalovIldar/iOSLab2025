import SwiftUI

struct AddFilmView: View {
    @Binding var film: Film
    let onCancel: () -> Void
    let onSave: (Film) -> Void

    private var canSave: Bool {
        !film.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        Form {
            Section("Основные данные") {
                TextField("Название", text: $film.name)
                    .textInputAutocapitalization(.words)
                
                TextField("Жанр", text: $film.category)
                
                TextField("Год выхода", value: $film.year, format: .number)
                    .keyboardType(.numberPad)
            }
            
            Section("Описание") {
                TextEditor(text: $film.notes)
                    .frame(minHeight: 140)
            }
        }
        .navigationTitle("Новый фильм")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Закрыть") {
                    onCancel()
                }
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button("Добавить") {
                    onSave(film)
                }
                .disabled(!canSave)
            }
        }
    }
}

#Preview {
    NavigationStack {
        AddFilmView(
            film: .constant(.draft),
            onCancel: {},
            onSave: { _ in }
        )
    }
}
