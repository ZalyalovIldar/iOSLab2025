//
//  AddSongView.swift
//  FavoritesApp
//
//  Created by Ляйсан 

import SwiftUI

struct AddSongView: View {
    @Environment(\.dismiss)
    private var dismiss
    
    @Bindable var songsViewModel: SongsViewModel
    
    var isValidInput: Bool {
        !songsViewModel.inputName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !songsViewModel.inputArtist.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(alignment: .leading) {
                    InputTitle(text: "Name")
                    Input(text: $songsViewModel.inputName)
                    
                    InputTitle(text: "Artist").padding(.top, 16)
                    Input(text: $songsViewModel.inputArtist)
                   
                    Spacer()
                }
                .padding(.top, 30)
                .padding(.horizontal)
            }
            .navigationTitle("New Song")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Task {
                            await songsViewModel.addSong()
                            dismiss()
                        }
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
    NavigationStack {
        AddSongView(songsViewModel: SongsViewModel(fileManager: LocalFileManager()))
    }
}
