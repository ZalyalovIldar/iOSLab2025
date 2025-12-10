//
//  UIImagePoster.swift
//  MovieBrowser
//
//  Created by Ляйсан on 9/12/25.
//

import SwiftUI

struct UIImagePoster: View {
    var image: UIImage
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFit()
            .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}
