//
//  PersonListView.swift
//  OOPSwift
//
//  Created by krnklvx on 05.10.2025.
//


import SwiftUI

struct PersonListView: View {
    @Binding var persons: [Person]
    let balanceMoney: (Person) -> Double
    let deletePerson: (IndexSet) -> Void
    
    var body: some View {
        VStack {
            Text("Список участников")
                .font(.headline)
                .padding(.bottom, 5)
            
            List {
                ForEach(persons) { person in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(person.name)
                                .font(.headline)
                            
                            Text("Потратил: \(person.amount, specifier: "%.2f")₽")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            let personBalance = balanceMoney(person)
                            
                            Text("\(personBalance >= 0 ?  "+" : "")\(personBalance, specifier: "%.2f")₽")
                                .font(.headline)
                                .foregroundColor(personBalance >= 0 ? .green: .red)
                            
                            Text(personBalance >= 0 ? "Получит" : "Должен")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                }
                .onDelete(perform: deletePerson)
            }
            .frame(height: 200)
        }
    }
}

