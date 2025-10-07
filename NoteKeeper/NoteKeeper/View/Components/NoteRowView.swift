//
//  NoteRowView.swift
//  NoteKeeper
//
//  Created by Artur Bagautdinov on 07.10.2025.
//

import SwiftUI

struct NoteRowView: View {
    
    let note: Note
    
    @Binding var noteToEdit: Note?
    
    @State private var isTextExpanded = false
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    var body: some View {
        
        VStack() {
            
            HStack {
                Text(note.title)
                    .font(.headline)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button {
                    noteToEdit = note
                } label: {
                    Image(systemName: "pencil.circle.fill")
                        .font(.title2)
                        .foregroundStyle(
                            LinearGradient(colors: [.blue, .purple],
                                           startPoint: .leading,
                                           endPoint: .trailing)
                        )
                }
                .buttonStyle(.plain)
            }
            
            Divider()
                .background(LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(note.text)
                    .font(.body)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(isTextExpanded ? nil : 3)
                
                if note.text.count > 100 {
                    Button(isTextExpanded ? "Hide" : "Show more...") {
                        isTextExpanded.toggle()
                    }
                    .buttonStyle(.plain)
                    .font(.caption)
                    .foregroundColor(.blue)
                }
            }
            
            VStack {
                Divider()
                Text("Created: \(dateFormatter.string(from: note.createdDate))")
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            .padding(.top, 8)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemGray6))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(LinearGradient(
                            colors: [.blue.opacity(0.3), .purple.opacity(0.3)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 3)
                )
        )
        .frame(width: 330)
    }
}

#Preview {
    let sampleNote = Note(
        title: "Shopping List",
        text: "Milk, Eggs, Bread, Bananas, Apples, Oranges, Tomatoes, Cucumbers, Chicken fillet, Salmon steaks, Cheese, Yogurt, Butter, Pasta, Rice, Coffee, Orange juice, Chocolate, Cookies, Potato, Carrot, Onion, Lettuce, Beef mince, Turkey mince, Almonds, Granola, Olive oil, Salt, Pepper, Dish soap, Laundry detergent, Garbage bags, Cat food",
        createdDate: Date()
    )
    return NoteRowView(note: sampleNote, noteToEdit: .constant(nil))
        .padding()
}
