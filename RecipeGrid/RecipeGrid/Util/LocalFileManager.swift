//
//  LocalFileManager.swift
//  RecipeGrid
//
//  Created by Ляйсан on 5/12/25.
//

import Foundation
import SwiftUI

final class LocalFileManager {
    static let shared = LocalFileManager()
    
    private init() {}
    
    func saveImage(image: UIImage, imageName: String, folderName: String) {
        createFolderIfNeeded(folderName: folderName)
        
        guard let data = image.pngData(),
              let url = getImageUrl(imageName: imageName, folderName: folderName) else { return }
        do {
            try data.write(to: url)
        } catch {
            print(error)
        }
    }
    
    func getImage(imageName: String, folderName: String) -> UIImage? {
        guard let url = getImageUrl(imageName: imageName, folderName: folderName),
              FileManager.default.fileExists(atPath: url.path) else { return nil }
        return UIImage(contentsOfFile: url.path)
    }
    
    private func createFolderIfNeeded(folderName: String) {
        guard let url = getFolderUrl(folderName: folderName) else { return }
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
            } catch {
                print(error)
            }
        }
    }
    
    private func getFolderUrl(folderName: String) -> URL? {
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
        return url.appendingPathComponent(folderName)
    }
    
    private func getImageUrl(imageName: String, folderName: String) -> URL? {
        guard let folderUrl = getFolderUrl(folderName: folderName) else { return nil }
        return folderUrl.appendingPathComponent(imageName)
        
    }
}
