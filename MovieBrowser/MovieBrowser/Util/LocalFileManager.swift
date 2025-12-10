//
//  LocalFileManager.swift
//  MovieBrowser
//
//  Created by Ляйсан on 8/12/25.
//

import Foundation
import SwiftUI

final class LocalFileManager {
    static let shared = LocalFileManager()
    
    private init() {}
    
    func getImage(imageName: String, folderName: String) -> UIImage? {
        guard let url = getImagePath(imageName: imageName, folderName: folderName),
              FileManager.default.fileExists(atPath: url.path) else { return nil }
        return UIImage(contentsOfFile: url.path)
    }
    
    func save(image: UIImage, imageName: String, folderName: String) {
        createFolderIfNeeded(folderName: folderName)
        guard let data = image.pngData(),
              let url = getImagePath(imageName: imageName, folderName: folderName) else { return }
        do {
            try data.write(to: url)
        } catch {
            print(error)
        }
    }
    
    func delete(imageName: String, folderName: String) {
        guard let url = getImagePath(imageName: imageName, folderName: folderName),
              FileManager.default.fileExists(atPath: url.path) else { return }
        
        try? FileManager.default.removeItem(at: url)
    }
    
    private func createFolderIfNeeded(folderName: String) {
        guard let url = getFolderPath(folderName: folderName) else { return }
        
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
            } catch {
                print(error)
            }
        }
    }
    
    private func getFolderPath(folderName: String) -> URL? {
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
        
        return url.appendingPathComponent(folderName)
    }
    
    private func getImagePath(imageName: String, folderName: String) -> URL? {
        guard let url = getFolderPath(folderName: folderName) else { return nil }
        
        return url.appendingPathComponent(imageName)
    }
}
