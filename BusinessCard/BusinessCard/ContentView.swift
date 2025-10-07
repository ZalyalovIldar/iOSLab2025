//
//  ContentView.swift
//  BusinessCard
//
//  Created by Artur Bagautdinov on 13.09.2025.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.colorScheme)
    var colorScheme
    
    @Environment(\.horizontalSizeClass)
    var horizontalSizeClass
    
    private var isiPad: Bool {
        horizontalSizeClass == .regular
    }
    
    var body: some View {
        
        ZStack {
            
            Color("backgroundColor")
                .ignoresSafeArea()
            
            VStack {
                
                VStack {
                    
                    Image("profilePhoto")
                        .resizable()
                        .scaledToFit()
                        .frame(width: isiPad ? 220 : 150, height: isiPad ? 220 : 150)
                        .clipShape(.circle)
                        .overlay(Circle()
                            .stroke(
                                colorScheme == .dark ? Color.white : Color.black,
                                lineWidth: isiPad ? 8 : 5))
                        .shadow(radius: isiPad ? 15 : 10)
                        
                    Text(LocalizedStringResource("name"))
                        .font(.custom("Arial Bold", size: isiPad ? 36 : 28))
                        .foregroundStyle(Color("textAccent"))
                    
                    Text(LocalizedStringResource("job_title"))
                        .font(.custom("Arial", size: isiPad ? 24 : 20))
                        .foregroundColor(.gray)
                }
                
                Divider()
                
                VStack(alignment: .leading, spacing: isiPad ? 15 : 10) {
                    
                    HStack {
                        Image(systemName: "phone.fill")
                        Text("+7 (222) 333-21-03")
                            .foregroundStyle(Color("textAccent"))
                    }
                    
                    HStack {
                        Image(systemName: "envelope.fill")
                        Text("artur.bagautdinov@gmail.com")
                    }
                    
                    HStack {
                        Image(colorScheme == .dark ? "githubNight" : "githubDay")
                            .resizable()
                            .scaledToFit()
                            .frame(width: isiPad ? 40 : 25, height: isiPad ? 40 : 25)
                        Text("https://github.com/ArturBagautdinov  ")
                    }
                    
                }
                .font(.custom("Arial", size: isiPad ? 22 : 18))
                .padding(isiPad ? 40 : 20)
                
                Spacer()
                
                HStack {
                    
                    ShareLink(item: createText()) {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                            Text(LocalizedStringResource("share_button"))
                        }
                        .font(.headline)
                        .padding(.horizontal, isiPad ? 20 : 10)
                        .padding(.vertical, isiPad ? 12 : 8)
                        .background(LinearGradient(
                            colors: colorScheme == .dark ? [Color.blue, Color.gray] : [Color.blue],
                            startPoint: .leading,
                            endPoint: .trailing
                        ))
                        .foregroundStyle(.white)
                        .cornerRadius(isiPad ? 25 : 20)
                        .shadow(radius: isiPad ? 15 : 10)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        print("Calling...")
                    }) {
                        HStack {
                            Image(systemName: "phone")
                            Text(LocalizedStringResource("call_button"))
                        }
                        .font(.headline)
                        .padding(.horizontal, isiPad ? 30 : 20)
                        .padding(.vertical, isiPad ? 15 : 10)
                        .background(LinearGradient(
                            colors: colorScheme == .dark ? [Color.blue, Color.gray] : [Color.green],
                            startPoint: .leading,
                            endPoint: .trailing
                        ))
                        .foregroundStyle(.white)
                        .cornerRadius(isiPad ? 25 : 20)
                        .shadow(radius: isiPad ? 15 : 10)
                    }
                    
                }
                .padding(.horizontal, isiPad ? 40 : 20)
                
            }
            .padding(isiPad ? 60 : 20)
            
        }
        
    }
    
}

private func createText() -> String {
    """
    \(String(localized: "name"))
    \(String(localized: "job_title"))
        
    \(String(localized: "phone_label")): +7 (222) 333-21-03
    \(String(localized: "email_label")): artur.bagautdinov@gmail.com
    \(String(localized: "github_label")): https://github.com/arturbagautdinov
    """
}

#Preview {
    ContentView()
}
