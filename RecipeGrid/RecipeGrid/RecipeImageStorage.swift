//
//  RecipeImageStorage.swift
//  RecipeGrid
//
//  Created by Artur Bagautdinov on 06.12.2025.
//

import Foundation

import UIKit

struct RecipeImageStorage {
    
    static let shared = RecipeImageStorage()
    
    private init() {}
    
    private var documentsURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    func save(image: UIImage, fileName: String) throws {
        let url = documentsURL.appendingPathComponent(fileName)
        guard let data = image.jpegData(compressionQuality: 0.9) else { return }
        try data.write(to: url, options: .atomic)
    }
    
    func load(fileName: String) -> UIImage? {
        let url = documentsURL.appendingPathComponent(fileName)
        return UIImage(contentsOfFile: url.path())
    }
}
