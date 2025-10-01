//
//  ContentView.swift
//  FirstTest
//
//  Created by Myrsus on 09.09.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var isDark = false
    
    
    var body: some View {
        VStack{
            VStack {
                Image(.dog)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 240,height: 240)
                    .offset(y: 40)
                    .clipShape(Circle())
                Text("Патни Каприз Шуджи Юкине")
                    .font(.title2)
                    .fontWeight(.bold)
                Divider()
                Text("Генеральный директор по всему на свете")
                    .font(.subheadline)
                
                
            }
            .padding(.bottom, 30)
            
            Button("Позвонить"){
                print("Звоню на телефон")
            }
            .buttonStyle(.borderedProminent)
            
            
            Spacer()
            
            VStack {
                Toggle("Тёмная тема", isOn: $isDark)
                    .padding()
                
            }
            
            
            VStack{
                HStack{
                    Image(systemName: "phone.fill")
                    Text("+79998887777")
                }
                HStack{
                    Image(systemName: "envelope.fill")
                    Text("dontwrite@dog.com")
                }
            }
        }
        .preferredColorScheme(isDark ? .dark : .light)

    }
}

#Preview {
    ContentView()
}
