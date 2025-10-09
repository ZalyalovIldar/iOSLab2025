//
//  NoteRowView.swift
//  hmwk_4
//
//  Created by krnklvx on 10.10.2025.
//


import SwiftUI

struct NoteRowView: View {
    let note: Note
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(note.title)
                    .font(.headline)
                    .lineLimit(1)
                Text(note.content)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(2)
            }
                Spacer()
                Text(note.date, style: .date)
                .font(.caption)
                .foregroundColor(.secondary)
                
            }
        .padding(.vertical, 6)
        .contentShape(Rectangle())
    }
}

#Preview {
    NoteRowView(note: Note(title: "Пример заметки", content: "Тестовый текст"))
}
