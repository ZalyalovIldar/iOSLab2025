//
//  ContentView 2.swift
//  OOPSwift
//
//  Created by krnklvx on 05.10.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var dataManager = DataManager()
    @State private var newName = ""
    @State private var newAmount = ""
    @State private var errorMessage = ""
    @State private var showingExportSheet = false
    @State private var showingImportSheet = false
    @State private var jsonText = ""
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Делим-делим")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top)
            
            ImportExportView(
                showingExportSheet: $showingExportSheet,
                showingImportSheet: $showingImportSheet,
                jsonText: $jsonText,
                exportToJSON: exportToJSON,
                importFromJSON: importFromJSON
            )
            .padding(.bottom)
            
            AddPersonView(
                persons: $dataManager.persons,
                newName: $newName,
                newAmount: $newAmount,
                errorMessage: $errorMessage
            )
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            if dataManager.persons.isEmpty {
                EmptyView()
            } else {
                PersonListView(
                    persons: $dataManager.persons,
                    balanceMoney: dataManager.balanceMoney,
                    deletePerson: deletePerson
                )
                SummaryView(
                    total: dataManager.total,
                    average: dataManager.average,
                    personsCount: dataManager.persons.count
                )
            }
            Spacer()
        }
        .padding()
        .onAppear {
            dataManager.loadFromUserDefaults()
        }
        .sheet(isPresented: $showingExportSheet) {
            ExportSheetView(jsonText: $jsonText, showingExportSheet: $showingExportSheet)
        }
        .sheet(isPresented: $showingImportSheet) {
            ImportSheetView(jsonText: $jsonText, showingImportSheet: $showingImportSheet, importFromJSON: importFromJSON)
        }
    }
    
    private func exportToJSON() {
        if let jsonString = dataManager.exportToJSON() {
            jsonText = jsonString
            showingExportSheet = true
        }
    }
    
    private func importFromJSON() {
        do {
            let importedPersons = try dataManager.importFromJSON(jsonText)
            dataManager.persons = importedPersons
            dataManager.saveToUserDefaults()
            showingImportSheet = false
            jsonText = ""
            errorMessage = ""
        } catch {
            errorMessage = "Ошибка импорта: неверные данные"
        }
    }
    
    private func deletePerson(at offset: IndexSet) {
        dataManager.persons.remove(atOffsets: offset)
        dataManager.saveToUserDefaults()
    }
}

#Preview {
    ContentView()
}

