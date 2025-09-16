//
//  ContentView.swift
//  Business Card
//
//  Created by Ляйсан on 11.09.2025.
//

import SwiftUI

//TODO: Text("Junior- iOS Developer")
//    .font(.title)
//    .bold()

struct MenuView: View {
    var menu = Menu()
    var body: some View {
        ZStack {
            Color(.systemGray6)
                .ignoresSafeArea()
            VStack {
                VStack {
                    Image(.profile)
                        .resizable()
                        .frame(width: 135, height: 130)
                        .clipShape(.circle)
                    Text("Laysan Minlebaeva")
                        .font(.title)
                        .bold()
                    Button {
                        print("The line is busy. Please try again later.")
                    } label: {
                        Text("\(Image(systemName: "phone.fill")) +7 (951) 064-93-69")
                    }
                }
                .padding(.horizontal, 57)
                .padding(.vertical, 20)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(.background)
                )

                VStack {
                    List(menu.categories) { category in
                        NavigationLink {
                            
                        } label: {
                            HStack {
                                Image(systemName: category.icon)
                                    .foregroundStyle(.white)
                                    .padding(4)
                                    .background(
                                        RoundedRectangle(cornerRadius: 5)
                                            .fill(category.iconBackgroundColor)
                                    )
                                Text(category.title)
                                    .font(.system(size: 18))
                            }
                        }
                        
                        
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(.background)
                       
                )
                
                
                Spacer()
            }
            
            
        }
        
        
    }
    


}

#Preview {
    MenuView()
}
