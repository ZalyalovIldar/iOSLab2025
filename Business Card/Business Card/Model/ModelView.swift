//
//  ModelView.swift
//  Business Card
//
//  Created by Ляйсан on 16.10.2025.
//

import Foundation
import SwiftUI
import PhotosUI

@Observable
class ModelView {
    var selectedImage: UIImage?
    var photoSelection: PhotosPickerItem? {
        didSet {
            setImage(selection: photoSelection)
        }
    }
    
    private func setImage(selection: PhotosPickerItem?) {
        guard let selection else { return }
        Task {
            do {
                let data = try await selection.loadTransferable(type: Data.self)
                guard let data, let image = UIImage(data: data) else { throw URLError(.badServerResponse) }
                await MainActor.run {
                    selectedImage = image
                }
            } catch {
                print(error)
            }
        }
    }
}
