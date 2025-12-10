//
//  ImagePlaceholder.swift
//  MovieBrowser
//
//  Created by Ляйсан on 9/12/25.
//

import SwiftUI

struct ImagePlaceholder: View {
    var body: some View {
        Image("questionmark")
            .resizable()
            .scaledToFit()
            .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    ImagePlaceholder()
}
