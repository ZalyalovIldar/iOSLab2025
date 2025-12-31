//
//  SongsView.swift
//  FavoritesApp
//
//  Created by Ляйсан 

import SwiftUI

struct SongsView: View {
    @Bindable var songsViewModel: SongsViewModel
    
    @State private var isAddingScreenShown = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(alignment: .leading) {
                    Title(text: "Playlist", color: .white)
                    
                    ForEach(songsViewModel.filteredSongs) { song in
                        NavigationLink {
                            EditView(songsViewModel: songsViewModel, song: song)
                        } label: {
                            SongRowView(song: song)
                        }
                    }
                    Spacer()
                }
            }
            .searchable(text: $songsViewModel.searchText, placement: .toolbar, prompt: "Search")
            .sheet(isPresented: $isAddingScreenShown, content: {
                AddSongView(songsViewModel: songsViewModel)
            })
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        Menu {
                            Button {
                                songsViewModel.isSortedByTitle.toggle()
                            } label: {
                                HStack {
                                    Image(systemName: songsViewModel.isSortedByTitle ? "checkmark" : " ")
                                    Text("Title")
                                }
                            }
                        } label: {
                            HStack {
                                Image(systemName: "arrow.up.arrow.down")
                                Text("Sort By")
                            }
                        }
                        Button(role: .destructive) {
                            Task {
                                await songsViewModel.deleteAll()
                            }
                        } label: {
                            HStack {
                                Image(systemName: "trash")
                                Text("Delete All")
                            }
                        }

                    } label: {
                        Image(systemName: "line.3.horizontal.decrease")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isAddingScreenShown = true
                    } label: {
                      Image(systemName: "plus")
                    }
                    .buttonStyle(.glassProminent)
                    .tint(.primaryRed)
                }  
            }
        }
    }
}

#Preview {
    NavigationStack {
        SongsView(songsViewModel: SongsViewModel(fileManager: LocalFileManager()))
    }
}
