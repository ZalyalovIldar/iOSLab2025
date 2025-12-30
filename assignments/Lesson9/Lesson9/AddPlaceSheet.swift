//
//  AddPlaceView.swift
//  Lesson9
//
//  Created by Timur Minkhatov on 29.12.2025.
//

import SwiftUI

struct AddPlaceSheet: View {
    let onAdd: (Place) -> Void
    
    @Environment(\.dismiss)
    private var dismiss
    
    @State private var name = ""
    @State private var country = ""
    @State private var year = ""
    @State private var notes = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Основная информация") {
                    TextField("Название места", text: $name)
                    TextField("Страна", text: $country)
                    TextField("Год посещения", text: $year)
                        .keyboardType(.numberPad)
                }
                
                Section("Заметки") {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                }
            }
            .navigationTitle("Новое место")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Добавить") {
                        savePlace()
                    }
                    .disabled(!isValid)
                }
            }
        }
    }
    
    private var isValid: Bool {
        !name.isEmpty && !country.isEmpty && !year.isEmpty
    }
    
    private func savePlace() {
        let place = Place(
            id: UUID(),
            name: name,
            country: country,
            year: year,
            notes: notes
        )
        onAdd(place)
        dismiss()
    }
}
