//
//  AddingMemberView.swift
//  ExpenseSplitter
//
//  Created by Ляйсан
//

import SwiftUI

struct AddingMemberView: View {
    @State private var textFieldsCounter = 2
    @State private var isValid = false 
    @State private var names = ["", "", "", ""]
    @State private var isExpenseViewShown = false
    
    
    var body: some View {
        NavigationStack {
            if isExpenseViewShown {
                ExpenseView(expenseViewModel: ExpenseViewModel(names: names))
            } else {
                VStack {
                    TitleView(text: "Members")
                        .padding(.horizontal, 10)
                    Spacer()
                    HStack(spacing: -90) {
                        Image(.expenseG)
                            .resizable()
                            .frame(width: 190, height: 160)
                            .offset(x: -20, y: -60)
                        Image(.expenseM)
                            .resizable()
                            .frame(width: 175, height: 160)
                            .offset(y: 60)
                    }
                    Spacer()
                    ForEach(0..<textFieldsCounter, id: \.self) { indicy in
                        TextField("Name", text: $names[indicy])
                            .padding()
                            .glassEffect()
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                }
                .padding()
                .background {
                    ZStack {
                        Color(.secondBack).ignoresSafeArea()
                        Circle()
                            .fill(.main)
                            .frame(width: 180, height: 180)
                            .blur(radius: 130)
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        ToolbarButton(image: "checkmark", disabledCondition: !validate(names)) {
                            isExpenseViewShown = true
                        }
                    }
                    ToolbarItem(placement: .bottomBar) {
                        ToolbarButton(image: "trash", disabledCondition: textFieldsCounter == 1) { textFieldsCounter -= 1
                        }
                    }
                    ToolbarSpacer(.flexible, placement: .bottomBar)
                    ToolbarItem(placement: .bottomBar) {
                        ToolbarButton(image: "plus", disabledCondition: textFieldsCounter == 4) { textFieldsCounter += 1
                        }
                    }
                }
            }
        }
    }
    
    private func validate(_ names: [String]) -> Bool {
        for index in 0..<textFieldsCounter {
            if names[index].isEmpty {
                return false
            }
        }
        return true
    }
}

#Preview {
    AddingMemberView()
}
