//
//  PhotoManager.swift
//  RecipeGrid
//
//  Created by Ляйсан on 4/12/25.
//

import Foundation
import SwiftUI
import PhotosUI

@Observable
final class PhotoSelectionViewModel {
    var image: UIImage? = nil
    var photoSelection: PhotosPickerItem? = nil {
        didSet {
            setImage(selection: photoSelection)
        }
    }
    
    private func setImage(selection: PhotosPickerItem?) {
        guard let selection else { return }
        Task {
            let data = try await selection.loadTransferable(type: Data.self)
            guard let data, let image = UIImage(data: data) else { return }
            await MainActor.run {
                self.image = image
            }
        }
    }
}
