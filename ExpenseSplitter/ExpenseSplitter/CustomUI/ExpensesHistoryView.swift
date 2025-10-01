//
//  AddingExpensesView.swift
//  ExpenseSplitter
//
//  Created by Ляйсан
//

import SwiftUI

struct ExpensesHistoryView: View {
    var category: Category
    @State private var isAddingSheetShown = false
    @State var expenseViewModel: ExpenseViewModel
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            Circle()
                .fill(category.color)
                .frame(width: 180, height: 180)
                .blur(radius: 130)
            VStack(alignment: .leading) {
                Text(category.rawValue.capitalized)
                    .font(.system(size: 34, weight: .bold))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("History  \(Image(systemName: "clock"))")
                    .padding(20)
                if let selectedUser = expenseViewModel.getSelectedUser(),
                   let expenses = selectedUser.expenses[category] {
                    RoundedRectangle(cornerRadius: 0)
                        .fill(category.color)
                        .frame(width: 370, height: 0.5)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 5)
                    ForEach(expenses.reversed()) { expense in
                        HStack {
                            Text(expense.name)
                                .font(.title2)
                            Spacer()
                            Text("-$\(expense.cost, specifier: "%.2f")")
                                .font(.title2)
                        }
                        .foregroundStyle(.white)
                        RoundedRectangle(cornerRadius: 0)
                            .fill(category.color)
                            .frame(width: 370, height: 0.5)
                    }
                    .listStyle(.plain)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                }
                Spacer()
                HStack {
                    Spacer()
                    Image(systemName: "plus")
                        .font(.title2)
                        .foregroundStyle(.black)
                        .padding()
                        .background {
                            Circle()
                                .fill(category.color)
                                .glassEffect(.regular.interactive())
                        }
                        .padding(.horizontal, 20)
                        .onTapGesture {
                            isAddingSheetShown = true
                        }
                }
            }
            .foregroundStyle(.white)
        }
        .sheet(isPresented: $isAddingSheetShown) {
            AddingExpensesView(expenseViewModel: expenseViewModel, category: category)
                .presentationDetents([.medium])
        }
    }
}

#Preview {
    ExpensesHistoryView(category: Category.health, expenseViewModel: ExpenseViewModel(names: ["Wednesday", "Enid"]))
}
