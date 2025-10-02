//
//  ContentView.swift
//  Practice
//
//  Created by Timur Minkhatov on 09.09.2025.
//

import SwiftUI
import MessageUI

struct ContentView: View {
    @AppStorage("isDarkMode") var isDarkMode = false
    @State var showShareSheet = false
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    Image("avatar")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 150, height: 150)
                        .offset(y: 25)
                        .clipShape(.rect(cornerRadius: 30))
                        .overlay(RoundedRectangle(cornerRadius: 30)
                            .stroke(Color.green, lineWidth: 4))
                        .shadow(radius: 10)
                        .contentShape(.rect(cornerRadius: 30))
                    
                    Text("Timur Minkhatov")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("iOS Developer and ex-hockey player of Ak Bars club")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                }
                
                Divider()
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "phone.fill")
                        Text("+7 (919)-634-94-54")
                    }
                    
                    HStack {
                        Image(systemName: "envelope.fill")
                        Text("timur.minkhatov@gmail.com")
                    }
                }
                .font(.headline)
                .padding()
                
                Spacer()
                
                HStack(spacing: 20) {
                    Button(action: {
                        callPhoneNumber()
                    }) {
                        Image(systemName: "phone.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .clipShape(Circle())
                    }
                    
                    Button(action: {
                        withAnimation {
                            isDarkMode.toggle()
                        }
                    }) {
                        Image(systemName: isDarkMode ? "sun.max.fill" : "moon.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.gray)
                            .clipShape(Circle())
                    }
                    
                    Button(action: {
                        showShareSheet = true
                    }) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.green)
                            .clipShape(Circle())
                    }
                }
                .padding(.bottom)
            }
            .padding()
            .navigationTitle("Профиль")
            .navigationBarTitleDisplayMode(.inline)
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(items: ["Посмотреть профиль"])
        }
    }
    
    private func callPhoneNumber() {
        let telephone = "+79196349454"
        guard let url = URL(string: telephone) else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    var items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    ContentView()
}
