//
//  LocalStorageError.swift
//  FavoritesApp
//
//  Created by Ляйсан 

import Foundation

enum LocalStorageError: Error {
    case invalidFilePath
    case noSuchFile
    case decodeError  
}
