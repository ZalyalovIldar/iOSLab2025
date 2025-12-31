//
//  EditView.swift
//  FavoritesApp
//
//  Created by Ляйсан 

import SwiftUI

struct EditView: View {
    @Environment(\.dismiss)
    private var dismiss
    
    @Bindable var songsViewModel: SongsViewModel
    let song: Song
    
    @State private var name: String
    @State private var artist: String
    
    var isValidInput: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !artist.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        (name != song.name || artist != song.artist)
    }
    
    init(songsViewModel: SongsViewModel, song: Song) {
        self.songsViewModel = songsViewModel
        self.song = song
        
        self._name = State(initialValue: song.name)
        self._artist = State(initialValue: song.artist)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(alignment: .leading) {
                    InputTitle(text: "Name")
                    Input(text: $name)
                    
                    InputTitle(text: "Artist").padding(.top, 16)
                    Input(text: $artist)
                   
                    Spacer()
                }
                .padding(.top, 30)
                .padding(.horizontal)
            }
            .navigationTitle("Edit Song")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Task {
                            await songsViewModel.updateSong(id: song.id, name: name, artist: artist)
                        }
                        dismiss()
                    } label: {
                        Image(systemName: "checkmark")
                    }
                    .buttonStyle(.glassProminent)
                    .disabled(!isValidInput)
                    .tint(isValidInput ? .primaryRed : .gray)
                }
            }
        }
    }
}

#Preview {
    EditView(songsViewModel: SongsViewModel(fileManager: LocalFileManager()), song: Song(name: "Ordinary", artist: "Alex Warren"))
}
