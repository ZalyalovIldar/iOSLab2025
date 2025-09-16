//
//  ContentView.swift
//  porfolio
//
//  Created by Никита Ефимов on 16.09.2025.
//
// BusinessCardPlusApp.swift

import SwiftUI


struct BusinessCardPlusApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .accentColor(.accentColor)
        }
    }
    
    struct ContentView: View {
        
        let name = "Филатчев Тимофей"
        let jobTitle = "iOS Developer"
        let phoneNumber = "+7 (987) 223-45-67"
        let email = "filtim@gmail.com"
        var body: some View {
            VStack(spacing: 20) {
                // MARK: - Фото
                Image("ProfilePhoto")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120) //
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(Color.accentColor, lineWidth: 4)
                    )
                    .shadow(radius: 5)
                
                VStack(spacing: 5) {
                    Text(name)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text(jobTitle)
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                
                Divider()
                
                
                VStack(alignment: .leading, spacing: 12) {
                    ContactRow(title: "Телефон", value: phoneNumber, icon: "phone")
                    ContactRow(title: "Email", value: email, icon: "envelope")
                }
                .padding(.horizontal)
                
                
                Button(action: {
                    print("📞 Звоним по номеру: \(phoneNumber)")
                }) {
                    HStack {
                        Image(systemName: "phone.fill")
                        Text("Позвонить")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.accentColor)
                    .cornerRadius(12)
                }
                .padding(.horizontal)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            .background(Color(UIColor.systemBackground))
        }
    }
    
    
    struct ContactRow: View {
        let title: String
        let value: String
        let icon: String
        
        var body: some View {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.accentColor)
                    .frame(width: 20, height: 20)
                
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(value)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                }
            }
        }
    }
    
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
                .previewDevice("iPhone 15 Pro")
            
            ContentView()
                .preferredColorScheme(.dark) // Просмотр в темной теме
                .previewDevice("iPhone 15 Pro")
        }
    }
}
