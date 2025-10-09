//
//  ExportSheetView.swift
//  OOPSwift
//
//  Created by krnklvx on 05.10.2025.
//

import SwiftUI

struct ExportSheetView: View {
    @Binding var jsonText: String
    @Binding var showingExportSheet: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                Text("JSON данные для экспорта:")
                    .font(.headline)
                    .padding()
                
                TextEditor(text: $jsonText)
                    .border(Color.gray)
                    .padding()
                
                Button("Скопировать") {
                    UIPasteboard.general.string = jsonText
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                Spacer()
            }
            .navigationTitle("Экспорт")
            .navigationBarItems(trailing: Button("Готово") {
                showingExportSheet = false
            })
        }
    }
}
