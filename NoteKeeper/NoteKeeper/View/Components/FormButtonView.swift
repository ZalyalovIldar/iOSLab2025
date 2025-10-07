//
//  FormButtonView.swift
//  NoteKeeper
//
//  Created by Artur Bagautdinov on 07.10.2025.
//

import SwiftUI

struct FormButtonView: View {
    
    @Binding var showAddSheet: Bool
    
    var body: some View {
        
        VStack(spacing: 5) {
            
            Button {
                showAddSheet = true
            } label: {
                HStack {
                    
                    Image(systemName: "plus.circle.fill")
                    Text("Add New Note")
                    
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .background(
                    LinearGradient(colors: [.blue, .purple],
                                   startPoint: .leading,
                                   endPoint: .trailing)
                        .cornerRadius(20)
                        .frame(width: 170, height: 40)
                )
            }
            
            Divider()
            
        }
    }
}

#Preview {
    FormButtonView(showAddSheet: .constant(false))
}
