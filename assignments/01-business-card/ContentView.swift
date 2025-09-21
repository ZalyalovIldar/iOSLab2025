//
//  ContentView.swift
//  homework1
//
//  Created by Анастасия on 16.09.2025.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        VStack {
            
            VStack {
                Image("E1724DCD-5C25-4825-B050-99FD981B79D6_1_105_c")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .clipShape(.circle)
                    .overlay(Circle()
                        .stroke(Color.gray, lineWidth: 4))
                    .shadow(radius: 10)
                
                Text("Nastya Shevchuk")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("ios developer)")
                    .font(.subheadline)
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 10) {
                
                HStack {
                    Image(systemName: "phone")
                    Text("+7 (912) 123-45-67")
                }
                
                HStack {
                    Image(systemName: "envelope")
                    Text("nastya.sobaka228@gmail.com")
                }
            }
            .font(.headline)
            .padding()
            
            Button(action: {
                print("Звоним на номер +7 (912) 123-45-67...")
            }) {
                Label("Call", systemImage: "phone")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(15)
            }
            
            
            ShareLink(
                item: "Анастасия Шевчук, ios developer, +7 (912) 123-45-67, nastya.sobaka228@gmail.com") {
                    Label("Share...", systemImage: "square.and.arrow.up")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                }
                .padding(.top, 5)

            Spacer()
            
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
