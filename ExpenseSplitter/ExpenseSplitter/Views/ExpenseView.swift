//
//  ExpenseView.swift
//  ExpenseSplitter
//
//  Created by Ляйсан
//

import SwiftUI
import Charts

struct ExpenseView: View {
    @State var expenseViewModel: ExpenseViewModel
    @State private var isAddingMemdersShown = false
    @State private var isToolbarExpanded = false
    @AppStorage("isContentUnvailablePageRequired") var isContentUnvailablePageRequired = false

    var body: some View {
        NavigationStack {
            if isContentUnvailablePageRequired {
                ContentUnavailableView()
            } else {
                ZStack {
                    Color.black.ignoresSafeArea()
                    Circle()
                        .fill(.purple)
                        .frame(width: 180, height: 180)
                        .blur(radius: 130)
                    VStack {
                        namesScrollView
                        HStack {
                            chart
                                .offset(x: -30)
                            VStack {
                                Text("to pay")
                                    .foregroundStyle(.white)
                                    .font(.callout)
                                Text("$\(expenseViewModel.totalToPay(), specifier: "%.2f")")
                                    .foregroundStyle(.main)
                                    .font(.system(size: 28, weight: .bold))
                            }
                        }
                        .background {
                            RoundedRectangle(cornerRadius: 25)
                                .fill(.secondary)
                                .frame(width: 363)
                                .glassEffect(.clear.interactive(), in: .rect(cornerRadius: 25))
                        }
                        .padding(.top, 10)
                        categoriesScrollView
                    }
                }
                .toolbar {
                    if isToolbarExpanded {
                        ToolbarItem(placement: .topBarTrailing) {
                            NavigationLink {
                                DeleteMembersView(expenseViewModel: expenseViewModel)
                            } label: {
                                Image(systemName: "person.2.fill")
                                    .foregroundStyle(.white)
                            }
                        }
                        
                        ToolbarItem(placement: .topBarTrailing) {
                            NavigationLink {
                                ResultView(expenseViewModel: expenseViewModel)
                            } label: {
                                Image(systemName: "creditcard.fill")
                                    .foregroundStyle(.white)
                            }
                        }
                       
                        ToolbarItem(placement: .topBarTrailing) {
                            Button {
                                withAnimation {
                                    isToolbarExpanded.toggle()
                                }
                            } label: {
                                Image(systemName: "gear")
                                    .foregroundStyle(.white)
                            }
                        }
                    } else {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button {
                                withAnimation {
                                    isToolbarExpanded.toggle()
                                }
                            } label: {
                                Image(systemName: "gear")
                                    .foregroundStyle(.white)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private var categoriesScrollView: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(), GridItem()]) {
                ForEach(Category.allCases, id: \.self) { category in
                    if category == .total {
                        CategoryView(category: category, backgroundColor: .secondary,  expenseViewModel: expenseViewModel, )
                            .frame(width: 170, height: 100)
                    } else {
                        NavigationLink {
                            if category != .total {
                                ExpensesHistoryView(category: category, expenseViewModel: expenseViewModel)
                            }
                            
                        } label: {
                            CategoryView(category: category, backgroundColor: .secondary,  expenseViewModel: expenseViewModel, )
                                .frame(width: 170, height: 100)
                            
                        }
                        .buttonStyle(.plain)
                    }
                    
                }
                .padding(.top, 10)
                .padding(.bottom, 50)
                .padding(.horizontal, 10)
            }
            .foregroundStyle(.white)
            .padding()
            .scrollTargetLayout()
            
        }
    }
    
    private var namesScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(expenseViewModel.users) { user in
                    Button {
                        expenseViewModel.selectedUserID = user.id
                    } label: {
                        Text("\(user.name)")
                            .font(.system(size: 34, weight: .bold))
                            .foregroundStyle(user.id == expenseViewModel.selectedUserID ? .main : Color(.systemGray))
                            .padding(.horizontal, 10)
                    }
                }
            }
        }
        .padding(.top, 15)
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private var chart: some View {
        if let selectedUser = expenseViewModel.getSelectedUser() {
            if !selectedUser.expenses.isEmpty {
                Chart {
                    ForEach(Array(selectedUser.expenses), id: \.key) { category, expense in
                        let total = expense.reduce(0) { $0 + $1.cost }
                        SectorMark(angle: .value("Amount", total), innerRadius: .ratio(0.618))
                            .foregroundStyle(category.color)
                    }
                }
                .padding()
                .frame(width: 170, height: 170)
            } else {
                Chart {
                    SectorMark(angle: .value("Amount", 100), innerRadius: .ratio(0.618))
                        .foregroundStyle(.gray.opacity(0.5))
                }
                .padding()
                .frame(width: 170, height: 170)
            }
        }
    }
}

#Preview {
    ExpenseView(expenseViewModel: ExpenseViewModel(names: ["Laysan", "Agnes"]))
}
