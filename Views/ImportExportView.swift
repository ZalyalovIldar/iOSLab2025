//
//  ImportExportView.swift
//  OOPSwift
//
//  Created by krnklvx on 05.10.2025.
//

import SwiftUI

struct ImportExportView: View {
    @Binding var showingExportSheet: Bool
    @Binding var showingImportSheet: Bool
    @Binding var jsonText: String
    let exportToJSON: () -> Void
    let importFromJSON: () -> Void
    
    var body: some View {
        HStack(spacing: 20) {
            Button("Экспорт JSON") {
                exportToJSON()
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
            
            Button("Импорт JSON") {
                showingImportSheet = true
            }
            .padding()
            .background(Color.orange)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }
}
