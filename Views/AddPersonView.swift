//
//  AddPersonView.swift
//  OOPSwift
//
//  Created by krnklvx on 05.10.2025.
//

import SwiftUI

struct AddPersonView: View {
    @Binding var persons: [Person]
    @Binding var newName: String
    @Binding var newAmount: String
    @Binding var errorMessage: String
    
    var body: some View {
        VStack(spacing: 15) {
            Text("Добавить участника")
                .font(.headline)
            
            HStack {
                Text("Имя: ")
                TextField("Введите имя", text: $newName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            HStack {
                Text("Сумма: ")
                TextField("Введите сумму", text: $newAmount)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            Button(action: addPerson) {
                Text("Добавить")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
            }
            .buttonStyle(.plain)
            .disabled(newName.isEmpty || newAmount.isEmpty)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
    
    private func addPerson() {
        let correctedName = newName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !correctedName.isEmpty else {
            errorMessage = "Имя не может быть пустым"
            return
        }
        
        guard !persons.contains(where: { $0.name.lowercased() == correctedName.lowercased() }) else {
            errorMessage = "Участник с таким именем уже существует"
            return
        }
        
        let correctedAmount = newAmount.replacingOccurrences(of: ",", with: ".")
        
        guard let amount = Double(correctedAmount), amount > 0 else {
            errorMessage = "Введите корректную сумму"
            return
        }
        
        let newPerson = Person(name: correctedName, amount: amount)
        persons.append(newPerson)
        
        newName = ""
        newAmount = ""
        errorMessage = ""
    }
}

