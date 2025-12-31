//
//  SongsViewModel.swift
//  FavoritesApp
//
//  Created by Ляйсан 

import Foundation

@Observable
final class SongsViewModel {
    let fileManager: LocalFileManager
    
    var songs: [Song] = []
    var isSortedByTitle = false
    
    var inputName = ""
    var inputArtist = ""
    var searchText = ""
    
    private let fileName = "favorites.json"
    
    var filteredSongs: [Song] {
        var result = songs
        
        if !searchText.isEmpty {
            result = result.filter { $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.artist.localizedCaseInsensitiveContains(searchText) }
        }
        
        if isSortedByTitle {
            result = result.sorted { $0.name < $1.name }
        }
        
        return result
    }
    
    init(fileManager: LocalFileManager) {
        self.fileManager = fileManager
        
        Task {
            await get()
        }
    }
    
    func get() async {
        do {
            let data = try await fileManager.getData(fileName: fileName)
            guard let songs = try? JSONDecoder().decode([Song].self, from: data) else { throw LocalStorageError.decodeError }
            
            self.songs = songs
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func addSong() async {
        let song = Song(name: inputName, artist: inputArtist)
        songs.append(song)
        
        if let data = convertToData() {
            await save(data: data)
        }
        
        inputName = ""
        inputArtist = ""
    }
    
    func updateSong(id: String, name: String, artist: String) async {
        if let index = songs.firstIndex(where: { $0.id == id }) {
            songs[index].name = name
            songs[index].artist = artist
            if let data = convertToData() {
                await save(data: data)
            }
        }
    }
    
    func deleteAll() async {
        do {
            try await fileManager.deleteAll(fileName: fileName)
            songs = []
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func save(data: Data) async {
        do {
            try await fileManager.save(data: data, fileName: fileName)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func convertToData() -> Data? {
        try? JSONEncoder().encode(songs)
    }
}
