//
//  ContentUnavailableView.swift
//  ExpenseSplitter
//
//  Created by Ляйсан
//

import SwiftUI

struct ContentUnavailableView: View {
    @State private var addMembersButtonPressed = false
    
    var body: some View {
        NavigationStack {
            if addMembersButtonPressed {
                AddingMemberView()
            } else {
                ZStack {
                    Color.black.ignoresSafeArea()
                    Circle()
                        .fill(.purple)
                        .frame(width: 180, height: 180)
                        .blur(radius: 130)
                    VStack {
                        Spacer()
                        Text("Add new members")
                            .foregroundStyle(.white.opacity(0.9))
                            .padding()
                        Button {
                            addMembersButtonPressed = true
                        } label: {
                            Image(systemName: "plus")
                        }
                        .buttonStyle(.glassProminent)
                        Spacer()
                    }
                }
            }
        }
    }
}

#Preview {
    ContentUnavailableView()
}
