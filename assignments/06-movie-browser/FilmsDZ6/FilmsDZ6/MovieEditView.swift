//
//  MovieEditView.swift
//  FilmsDZ6
//
//  Created by Иван Метальников on 11.12.2025.
//

import Foundation
import SwiftUI

struct MovieEditView: View{
    
    @Binding var movie: Movie
    
    var body: some View{
        Form{
            Section("Название"){
                TextField("Название", text: $movie.title)
            }
            Section("Жанр"){
                TextField("Жанр",text: $movie.genre)
            }
            Section("Описание"){
                TextField("Описание", text: $movie.description)
            }
            Section("Год выпуска"){
                TextField("Год выпуска", value: $movie.realeseYear, format: .number)
                    .keyboardType(.numberPad)
            }
        }
    }
}
