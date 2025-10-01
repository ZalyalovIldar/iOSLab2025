//
//  ContentView.swift
//  ExpenseSplitter
//
//  Created by Artur Bagautdinov on 29.09.2025.
//

import SwiftUI
import Charts

struct ContentView: View {
    
    @StateObject private var expVM = ExpenseViewModel()
    
    var body: some View {
        
        ScrollView {
            
            VStack {
                
                TitleView()
                
                AddParticipantView(expVM: expVM)
                
                Divider()
                
                ParticipantsListView(expVM: expVM)
                    .frame(minHeight: 250)
                
                DeleteAllButton(expVM: expVM)
                
                Divider()
                
                ResultsView(expVM: expVM)
                
                ExpensesPieChartView(expVM: expVM)
                
            }
            .padding()
        }
    }
}

struct AddParticipantView: View {
    
    @ObservedObject var expVM: ExpenseViewModel
    
    var body: some View {
        
        VStack(spacing: 10) {
            
            TextField("Name", text: $expVM.newName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Expense", text: $expVM.newExpense)
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button("Add") {
                expVM.addParticipant()
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

struct ResultsView: View {
    
    @ObservedObject var expVM: ExpenseViewModel
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 6) {
            
            Text("Results:")
                .font(.headline)
            
            ForEach(expVM.balances().sorted(by: { $0.key < $1.key }), id: \.key) { name, balance in
                HStack {
                    Text(name)
                    Spacer()
                    if balance > 0 {
                        Text("Should receive \(balance, specifier: "%.2f") ₽")
                            .foregroundColor(.green)
                    } else if balance < 0 {
                        Text("Should pay \(-balance, specifier: "%.2f") ₽")
                            .foregroundColor(.red)
                    } else {
                        Text("Settled up")
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .padding()
    }
}

struct ParticipantsListView: View {
    
    @ObservedObject var expVM: ExpenseViewModel
    
    var body: some View {
        
        if expVM.participants.isEmpty {
            ContentUnavailableView(
                "No Participants",
                systemImage: "person.3.sequence.fill",
                description: Text("Add friends to start splitting expenses")
            )
            .foregroundStyle(.gray)
            .padding()
        } else {
            List {
                ForEach(expVM.participants) { participant in
                    HStack {
                        
                        Text(participant.name)
                        
                        Spacer()
                        
                        let balance = expVM.balances()[participant.name] ?? 0
                        
                        Text("\(participant.expense, specifier: "%.2f") ₽")
                            .foregroundColor(balance > 0 ? .green : (balance < 0 ? .red : .gray))
                        
                        Button {
                            expVM.removeParticipant(participant)
                        } label: {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }
}

struct ExpensesPieChartView: View {
    
    @ObservedObject var expVM: ExpenseViewModel
    
    var body: some View {
        
        if expVM.participants.isEmpty {
            Text("No data to display")
                .foregroundColor(.gray)
                .padding()
        } else {
            Chart {
                ForEach(expVM.participants) { participant in
                    SectorMark(
                        angle: .value("Expense", participant.expense),
                        innerRadius: .ratio(0.5),
                        angularInset: 1
                    )
                    .foregroundStyle(by: .value("Participant", participant.name))
                    .annotation(position: .overlay) {
                        Text(participant.name)
                            .font(.caption2)
                            .foregroundColor(.white)
                    }
                }
            }
            .chartLegend(.visible)
            .frame(height: 300)
            .padding()
        }
    }
}

struct DeleteAllButton: View {
    
    @ObservedObject var expVM: ExpenseViewModel
    
    var body: some View {
        
        Button() {
            expVM.clearAll()
        } label: {
            Label("Clear All", systemImage: "trash")
        }
        .foregroundStyle(.red)
    }
}

struct TitleView: View {
    
    var body: some View {
        
        Text("Expense Splitter")
            .foregroundStyle(Gradient(colors: [.black, .blue, .black]))
            .font(.largeTitle)
            .fontWeight(.bold)
            .padding()
    }
}

#Preview {
    ContentView()
}
