//
//  ContentView.swift
//  SwiftUILesson_1
//
//  Created by lunn on 06.09.2025.

import SwiftUI

struct ContentView: View {
    @State private var isDark = false
    private let gradientColors = [Color.blue, Color.purple, Color.pink]
    private var dynamicAccent: Color {
        isDark ? .black : .white
    }
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: gradientColors),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Image("myPhoto")
                    .resizable()
                    .frame(width: 140, height: 140)
                    .clipShape(Circle())
                Text("Айлина Маратовна")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(dynamicAccent)
                Text("iOS Developer")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(dynamicAccent.opacity(0.8))
                Divider()
                    .background(dynamicAccent.opacity(0.7))
                    .padding(.horizontal, 40)
                
                RoundedRectangle(cornerRadius: 20)
                    .fill(dynamicAccent.opacity(0.2))
                    .frame(height: 57)
                    .overlay(
                        HStack {
                            Image(systemName: "phone.fill")
                                .foregroundColor(dynamicAccent)
                            Text("+7 (908) 456-78-91")
                                .foregroundColor(.white)
                                .fontWeight(.medium)
                        }
                        .padding(.horizontal, 20)
                    )
                    .shadow(radius: 5)
                    .padding(.horizontal)
                
                RoundedRectangle(cornerRadius: 20)
                    .fill(dynamicAccent.opacity(0.2))
                    .frame(height: 57)
                    .overlay(
                        HStack {
                            Image(systemName: "envelope.fill")
                                .foregroundColor(dynamicAccent)
                            Text("ailinyashka75@gmail.com")
                                .foregroundColor(.white)
                                .fontWeight(.medium)
                        }
                        .padding(.horizontal, 20)
                    )
                    .shadow(radius: 6)
                    .padding(.horizontal)
                
                Button(action: {
                    print("Звоню...")
                }) {
                    Text("Позвонить")
                        .font(.headline)
                        .foregroundColor(isDark ? .white : .gray)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(dynamicAccent)
                        .cornerRadius(14)
                        .shadow(radius: 6)
                }
                .padding(.horizontal)
                
                Toggle(isOn: $isDark) {
                    Text("Тёмная тема")
                        .foregroundColor(dynamicAccent)
                        .font(.subheadline)
                }
                .toggleStyle(SwitchToggleStyle(tint: dynamicAccent))
                .padding()
            }
            .padding()
        }
        .preferredColorScheme(isDark ? .dark : .light)
    }
}
#Preview {
    ContentView()
}
