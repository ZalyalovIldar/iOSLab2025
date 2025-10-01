//
//  DeleteMembersView.swift
//  ExpenseSplitter
//
//  Created by Ляйсан
//

import SwiftUI

struct DeleteMembersView: View {
    @Environment(\.dismiss) private var dismiss
    @State var expenseViewModel: ExpenseViewModel
    @State var selectedUsersIdsToDelete: [String] = []
    @State var isSelected = [false, false, false, false]
    @State var userIdsToDelete: [UUID] = []
    @AppStorage("isContentUnvailablePageRequired") var isContentUnvailablePageRequired = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                background
                VStack {
                    TitleView(text: "Active Members")
                        .padding(.vertical)
                        .padding(.horizontal, 25)
                        .padding(.bottom, 15)
                    membersList
                    Spacer()
                }
            }
            .toolbar {
                ToolbarSpacer(.flexible, placement: .bottomBar)
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        expenseViewModel.deleteUser(ids: userIdsToDelete)
                        if expenseViewModel.users.isEmpty {
                            isContentUnvailablePageRequired = true
                            dismiss()
                        }
                    } label: {
                        Image(systemName: "trash")
                            .foregroundStyle(.red)
                    }
                }
            }
        }
    }
    
    private var membersList: some View {
        ForEach(Array(expenseViewModel.users.enumerated()), id: \.offset) { index, user in
            HStack {
                Button {
                    isSelected[index].toggle()
                    if isSelected[index] {
                        userIdsToDelete.append(user.id)
                    }
                } label: {
                    Image(systemName: isSelected[index] ? "checkmark.circle" : "circle")
                        .foregroundStyle(.green.opacity(0.9))
                }
                Text(user.name)
                    .foregroundStyle(Color(.systemGray5))
                    .font(.system(size: 18, weight: .semibold))
                Spacer()
            }
            .padding()
            .glassEffect(.clear)
        }
        .padding(.horizontal)
        .padding(.vertical, 5)
    }
    
    @ViewBuilder
    private var background: some View {
        Color.black.ignoresSafeArea()
        Circle()
            .fill(.green.opacity(0.8))
            .frame(width: 180, height: 180)
            .blur(radius: 130)
    }
}

#Preview {
    DeleteMembersView(expenseViewModel: ExpenseViewModel(names: ["Laysan", "Agnes"]))
}
