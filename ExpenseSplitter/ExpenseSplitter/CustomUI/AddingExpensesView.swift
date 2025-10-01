//
//  AddingExpensesView.swift
//  ExpenseSplitter
//
//  Created by Ляйсан
//

import SwiftUI

struct AddingExpensesView: View {
    @Environment(\.dismiss)
    private var dismiss
    @State private var nameOfExpense = ""
    @State private var price = ""
    @State private var isInvalidInput = false
    @State private var alertMessage = ""
    @State var expenseViewModel: ExpenseViewModel
    var category: Category
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.secondBack).ignoresSafeArea()
                VStack {
                    TextField("Name", text: $nameOfExpense)
                        .foregroundStyle(.white)
                        .padding()
                        .glassEffect()
                    TextField("Price", text: $price)
                        .foregroundStyle(.white)
                        .padding()
                        .glassEffect()
                    Spacer() 
                }
                .padding()
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button {
                            validate()
                            if !isInvalidInput {
                                expenseViewModel.addExpenseByCategory(expense: Expense(name: nameOfExpense, cost: Double(price)!, category: category), category: category)
                                dismiss()
                            }
                        } label: {
                            Image(systemName: "checkmark")
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(category.color)
                    }
                }
                .alert(isPresented: $isInvalidInput) {
                    Alert(title: Text("Invalid Input"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
            }
        }
    }
    
    private func validate() {
        if Double(price) != nil {
           isInvalidInput = false
        } else {
            alertMessage = "Enter price in format: 10.45 or 11"
            isInvalidInput = true
        }
        if nameOfExpense.isEmpty || price.isEmpty {
            alertMessage = "Fill all required fields"
            isInvalidInput = true
        }
    }
}

#Preview {
    AddingExpensesView(expenseViewModel: ExpenseViewModel(names: ["Laysan", "Agnes"]), category: Category.clothing)
}
