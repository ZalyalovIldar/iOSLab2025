//
//  ContentView.swift
//  SwiftUILesson_1
//
//  Created by Айнур on 08.09.2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            VStack(spacing: 5) {
                Image("avatar_putin")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .clipShape(.circle)
                    .shadow(radius: 10)
                
                Text(NSLocalizedString("name", comment: "User's full name"))
                    .font(.title)
                    .fontWeight(.bold)
                
                Text(NSLocalizedString("job_title", comment: "User's position at job"))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: "phone.fill")
                    Text("+7 (919) 777-77-77")
                        .textSelection(.enabled)
                }
                
                HStack {
                    Image(systemName: "envelope.fill")
                    Text("aynur.saitov@gmail.com")
                        .textSelection(.enabled)
                }
            }
            .font(.headline)
            .padding()
            
            Spacer()
            
            HStack(spacing: 20) {
                Button {
                    print(NSLocalizedString("calling...", comment: "Calling..."))
                } label: {
                    VStack {
                        Image(systemName: "phone.circle.fill")
                            .font(.title)
                            
                        Text(NSLocalizedString("call", comment: "Call"))
                            .fontWeight(.semibold)
                            
                    }
                    .frame(width: 130, height: 50)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(30)
                    
                }
                .shadow(radius: 10)
                
                Button {
                    print("тут должно быть реализовано ShareSheet...")
                } label: {
                    VStack {
                        Image(systemName: "square.and.arrow.up.on.square.fill")
                            .font(.title)

                        Text(NSLocalizedString("share", comment: "share"))
                            .fontWeight(.semibold)
                    }
                    .frame(width: 130, height: 50)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(30)
                }
                .shadow(radius: 10)
            }
        }
        .padding(.bottom, 0)
        .background(Color(.systemBackground))
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.light)
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
