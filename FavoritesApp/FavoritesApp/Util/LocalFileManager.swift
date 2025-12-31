//
//  LocalFileManager.swift
//  FavoritesApp
//
//  Created by Ляйсан

import Foundation

actor LocalFileManager {
    func getData(fileName: String) throws -> Data {
        let url = try getFilePath(fileName: fileName)
        let data = try Data(contentsOf: url)
        
        return data
    }
    
    func save(data: Data, fileName: String) throws {
        let url = try getFilePath(fileName: fileName)
        
        try data.write(to: url, options: .atomic)
    }
    
    func deleteAll(fileName: String) throws {
        let url = try getFilePath(fileName: fileName)
        
        guard FileManager.default.fileExists(atPath: url.path) else { throw LocalStorageError.noSuchFile }
        try FileManager.default.removeItem(at: url)
    }
    
    private func getFilePath(fileName: String) throws -> URL {
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { throw LocalStorageError.invalidFilePath }
        
        return url.appendingPathComponent(fileName)
    }
}
