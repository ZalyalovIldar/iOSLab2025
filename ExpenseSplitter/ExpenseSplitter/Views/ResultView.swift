//
//  DeleteMembersView.swift
//  ExpenseSplitter
//
//  Created by Ляйсан
//

import SwiftUI

struct ResultView: View {
    @State var expenseViewModel: ExpenseViewModel
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            Circle()
                .fill(.red.opacity(0.75))
                .frame(width: 180, height: 180)
                .blur(radius: 130)
            VStack {
                TitleView(text: "Payments")
                    .padding(.vertical)
                    .padding(.horizontal, 25)
                List(expenseViewModel.users) { user in
                    HStack {
                        Text(user.name)
                            .foregroundStyle(Color(.systemGray5))
                        Spacer()
                        Text("$\(expenseViewModel.totalToPay(), specifier: "%.2f")")
                            .foregroundStyle(.red.opacity(0.8))
                    }
                    
                    .listRowBackground(Color.clear)
                }
                .padding()
                .listStyle(.plain)
                Spacer()
            }
        }
    }
}

#Preview {
    ResultView(expenseViewModel: ExpenseViewModel(names: ["Laysan", "Agnes"]))
}
