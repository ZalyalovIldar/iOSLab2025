//
//  ContentView.swift
//  ExpenseSplitter
//
//  Created by Artur Bagautdinov on 29.09.2025.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var vm = ExpenseViewModel()
    
    var body: some View {
        VStack {
            
            TitleView()
            
            AddParticipantView(vm: vm)
            
            ParticipantsListView(vm: vm)
            
            Button() {
                vm.clearAll()
            } label: {
                Label("Clear All", systemImage: "trash")
            }
            .foregroundStyle(.red)
            
            ResultsView(vm: vm)
            
        }
        .padding()
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
        
        List {
            ForEach(vm.participants) { participant in
                HStack {
                    Text(participant.name)
                    Spacer()
                    Text("\(participant.expense, specifier: "%.2f") ₽")
                    
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
