//
//  SongRowView.swift
//  FavoritesApp
//
//  Created by Ляйсан

import SwiftUI

struct SongRowView: View {
    let song: Song
    
    var body: some View {
        HStack {
           Image("placeholder")
                .resizable()
                .frame(width: 30, height: 30)
            Text(song.name)
        
            Spacer()
            Image(systemName: "play.fill")
                .font(.subheadline)
                .padding(.trailing, 10)
            Image(systemName: "forward.fill")
                .foregroundStyle(.gray)
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 18)
        .padding(.vertical, 10)
        .glassEffect(.clear, in: .rect(cornerRadius: 25))
        .padding(.horizontal)
    }
}

#Preview {
    SongRowView(song: Song(name: "Ordinary", artist: "Alex Warren"))
}
