//
//  CategoryView.swift
//  ExpenseSplitter
//
//  Created by Ляйсан
//

import SwiftUI

struct CategoryView: View {
    var category: Category
    var backgroundColor: Color
    var expenseViewModel: ExpenseViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(category.rawValue.capitalized)
                    .font(.system(size: 21, weight: .bold))
                Spacer()
                Image(systemName: category != .total ? "chevron.right": "")
                    .foregroundStyle(Color(.systemGray))
            }
            Text(category != .total ? "Total" : "Personal")
                .font(.system(size: 18))
                .padding(.top, 30)
            Text(category != .total ? "$\(expenseViewModel.totalCostByCategory(category: category), specifier: "%.2f")" : "$\(expenseViewModel.totalPersonalPrice(), specifier: "%.2f")")
                .font(.system(size: 26, weight: .semibold))
                .foregroundStyle(Color(category.color))
        }
        .foregroundStyle(.white)
        .padding(20)
        .background {
            RoundedRectangle(cornerRadius: 25)
                .fill(backgroundColor)
                .glassEffect(.clear.interactive(), in: .rect(cornerRadius: 25))
        }   
    }
}

#Preview {
    CategoryView(category: Category.clothing, backgroundColor: Color(.systemBlue), expenseViewModel: ExpenseViewModel(names: ["Wednesday", "Enid"]))
}
