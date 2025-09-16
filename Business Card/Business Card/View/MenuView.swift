//
//  ContentView.swift
//  Business Card
//
//  Created by Ляйсан on 11.09.2025.
//

import SwiftUI

struct MenuView: View {
    @Environment(\.colorScheme)
    private var colorScheme
    
    private var menu = DataStorage()
    
    var body: some View {
        ZStack {
            Color(colorScheme == .dark ? .black : .secondarySystemBackground).ignoresSafeArea()
            VStack {
                Text("Business Card")
                    .font(.largeTitle)
                    .bold()
                    .padding(.trailing, 135)
                    .padding(.top, 40)
                shortenedBio
                menuNavigation
                Spacer()
            }
        }
    }
    
    private var shortenedBio: some View {
        VStack {
            Image(.profile)
                .resizable()
                .frame(width: 130, height: 140)
                .clipShape(.circle)
            Text("Laysan Minlebaeva")
                .font(.title)
                .bold()
            Text("iOS Developer")
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 57)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(colorScheme == .dark ? Color(.secondarySystemBackground) : .white)
        )
    }
    
    private var menuNavigation: some View {
        VStack {
            List(menu.categories) { category in
                NavigationLink {
                    switch category.categoryType {
                    case .personalInformation: PersonalInformationView()
                    case .display: DisplayView()
                    }
                } label: {
                    HStack {
                        Image(systemName: category.icon)
                            .foregroundStyle(.white)
                            .padding(4)
                            .background(
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(category.iconBackgroundColor)
                            )
                        category.title
                            .font(.system(size: 18))
                    }
                }
            }
        }
    }
}


#Preview {
    MenuView()
}
