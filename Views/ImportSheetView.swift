//
//  ImportSheetView.swift
//  OOPSwift
//
//  Created by krnklvx on 05.10.2025.
//

import SwiftUI

struct ImportSheetView: View {
    @Binding var jsonText: String
    @Binding var showingImportSheet: Bool
    let importFromJSON: () -> Void
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Вставьте JSON данные:")
                    .font(.headline)
                    .padding()
                
                TextEditor(text: $jsonText)
                    .border(Color.gray)
                    .padding()
                
                Button("Импортировать") {
                    importFromJSON()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .disabled(jsonText.isEmpty)
                
                Spacer()
            }
            .navigationTitle("Импорт")
            .navigationBarItems(trailing: Button("Отмена") {
                showingImportSheet = false
                jsonText = ""
            })
        }
    }
}

