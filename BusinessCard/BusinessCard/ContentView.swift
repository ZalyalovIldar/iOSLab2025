//
//  ContentView.swift
//  BusinessCard
//
//  Created by Artur Bagautdinov on 13.09.2025.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        ZStack {
            
            Color("backgroundColor")
                .ignoresSafeArea()
            
            VStack {
                
                VStack {
                    
                    Image("profilePhoto")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .clipShape(.circle)
                        .overlay(Circle()
                            .stroke(
                                colorScheme == .dark ? Color.white : Color.black,
                                lineWidth: 5))
                        .shadow(radius: 10)
                    
                    Text("Artur Bagautdinov")
                        .font(.custom("Arial Bold", size: 28))
                    
                    Text("iOS Developer")
                        .font(.custom("Arial", size: 20))
                        .foregroundColor(.gray)
                    
                }
                
                Divider()
                
                VStack(alignment: .leading, spacing: 10) {
                    
                    HStack {
                        Image(systemName: "phone.fill")
                        Text("+7 (222) 333-21-03")
                    }
                    
                    HStack {
                        Image(systemName: "envelope.fill")
                        Text("artur.bagautdinov@gmail.com")
                    }
                    
                    HStack {
                        Image(colorScheme == .dark ? "githubNight" : "githubDay")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                        Text("https://github.com/arturbagautdinov")
                    }
                    
                }
                .font(.custom("Arial", size: 18))
                .padding()
                
                Spacer()
                
                Button(action: {
                    print("Calling...")
                }) {
                    HStack {
                        Image(systemName: "phone")
                        Text("Call")
                    }
                    .font(.headline)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(LinearGradient(
                        colors: colorScheme == .dark ? [Color.blue, Color.gray] : [Color.green],
                        startPoint: .leading,
                        endPoint: .trailing
                    ))
                    .foregroundStyle(.white)
                    .cornerRadius(20)
                    .shadow(radius: 10)
                }
            }
            .padding()
        }
    }
}


#Preview {
    ContentView()
}
