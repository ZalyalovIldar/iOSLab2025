//
//  ContentView.swift
//  ExpenseSplitter
//
//  Created by Artur Bagautdinov on 29.09.2025.
//

import SwiftUI
import Charts

struct ContentView: View {
    
    @StateObject private var vm = ExpenseViewModel()
    
    var body: some View {
        
        ScrollView {
            
            VStack {
                
                TitleView()
                
                AddParticipantView(vm: vm)
                
                Divider()
                
                ParticipantsListView(vm: vm)
                    .frame(minHeight: 250)
                
                DeleteAllButton(vm: vm)
                
                Divider()
                
                ResultsView(vm: vm)
                
                ExpensesPieChartView(vm: vm)
                
            }
            .padding()
        }
    }
}

struct AddParticipantView: View {
    
    @ObservedObject var vm: ExpenseViewModel
    
    var body: some View {
        
        VStack(spacing: 10) {
            
            TextField("Name", text: $vm.newName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Expense", text: $vm.newExpense)
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button("Add") {
                vm.addParticipant()
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

struct ResultsView: View {
    
    @ObservedObject var vm: ExpenseViewModel
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 6) {
            
            Text("Results:")
                .font(.headline)
            
            ForEach(vm.balances().sorted(by: { $0.key < $1.key }), id: \.key) { name, balance in
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
    
    @ObservedObject var vm: ExpenseViewModel
    
    var body: some View {
        
        if vm.participants.isEmpty {
            ContentUnavailableView(
                "No Participants",
                systemImage: "person.3.sequence.fill",
                description: Text("Add friends to start splitting expenses")
            )
            .foregroundStyle(.gray)
            .padding()
        } else {
            List {
                ForEach(vm.participants) { participant in
                    HStack {
                        
                        Text(participant.name)
                        
                        Spacer()
                        
                        let balance = vm.balances()[participant.name] ?? 0
                        
                        Text("\(participant.expense, specifier: "%.2f") ₽")
                            .foregroundColor(balance > 0 ? .green : (balance < 0 ? .red : .gray))
                        
                        Button {
                            vm.removeParticipant(participant)
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
    
    @ObservedObject var vm: ExpenseViewModel
    
    var body: some View {
        
        if vm.participants.isEmpty {
            Text("No data to display")
                .foregroundColor(.gray)
                .padding()
        } else {
            Chart {
                ForEach(vm.participants) { participant in
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

struct DeleteAllButton : View {
    
    @ObservedObject var vm: ExpenseViewModel
    
    var body: some View {
        
        Button() {
            vm.clearAll()
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
