//
//  PhotoSelectionViewModel.swift
//  MovieBrowser
//
//  Created by Ляйсан on 7/12/25.
//

import Foundation
import SwiftUI
import PhotosUI

@Observable
final class PhotoSelectionViewModel {
    var image: UIImage?
    var selection: PhotosPickerItem? {
        didSet {
            setImage(selection: self.selection)
        }
    }
    
    func setImage(selection: PhotosPickerItem?) {
        guard let selection else { return }
        
        Task {
            let data = try? await selection.loadTransferable(type: Data.self)
            guard let data, let image = UIImage(data: data) else { return }
            
            await MainActor.run {
                self.image = image
            }
        }
    }
}
