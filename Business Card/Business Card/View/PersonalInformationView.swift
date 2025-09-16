//
//  MoreDetailsView.swift
//  Business Card
//
//  Created by Ляйсан on 12.09.2025.
//

import SwiftUI

struct PersonalInformationView: View {
    @AppStorage("isAccentColor") private var accentColor = "systemBlue"
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ZStack {
            Color(colorScheme == .dark ? .black : .secondarySystemBackground).ignoresSafeArea()
            VStack {
                Text("Personal Information")
                    .font(.title3)
                    .fontWeight(.semibold)
                shortBio
                Text("INFO")
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
                    .padding(.top, 25)
                    .padding(.trailing, 310)
                info
                Spacer()
                HStack {
                    shareButton
                        .offset(x: -120)
                    callButton
                        .offset(x: -30)
                }
            }
        }
        .padding(.top, -34)
    }
    
    private var info: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Junior- iOS Developer")
                .font(.title3)
                .bold()
            VStack(alignment: .leading, spacing: 7) {
                Text("- basic skills in SwiftUI")
                divider
                Text("- experience in developing simple learning app")
                divider
                Text("- essential knowledge of Git/GitHub")
                divider
                Text("- fundamentals of programming in Java ")
            }
            .font(.system(size: 16))
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(colorScheme == .dark ? Color(.secondarySystemBackground) : .white)
        )
    }
    
    private var divider: some View {
        Divider()
            .frame(width: 330, height: 1)
    }
    
    @ViewBuilder
    private var shareButton: some View {
        if let url = DataStorage.gitHubAccountLink {
            ShareLink(item: url) {
                Image(systemName: "square.and.arrow.up").resizable()
                    .foregroundStyle(DataStorage.stringToColor(color: accentColor))
                    .frame(width: 20, height: 25)
                    .padding()
            }
        } else {
            Image(systemName: "square.and.arrow.up").resizable()
                .foregroundStyle(DataStorage.stringToColor(color: accentColor))
                .frame(width: 20, height: 25)
                .padding()
        }
    }
    
    private var callButton: some View {
        Button {
            print("The line is busy. Please try again later.")
        } label: {
            Image(systemName: "phone.fill").resizable()
                .foregroundStyle(.white)
                .frame(width: 35, height: 35)
                .padding()
                .background(
                    Circle()
                        .fill(Color(.systemGreen))
                        .frame(width: 70, height: 70)
                )
        }
    }
    
    private var shortBio: some View {
        VStack {
            Image(.profileDescription).resizable()
                .frame(width: 170, height: 200)
                .clipShape(.circle)
            Text("Laysan Minlebaeva")
                .font(.title)
                .bold()
            Button {
                print("How can I help you?")
            } label: {
                Text("lajsanminlebaeva@mail.ru")
            }
        }
    }
}

#Preview {
    PersonalInformationView()
}
