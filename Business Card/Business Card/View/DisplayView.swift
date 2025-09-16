//
//  DisplayView.swift
//  Business Card
//
//  Created by Ляйсан on 12.09.2025.
//

import SwiftUI

struct DisplayView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("isAccentColor") private var accentColor = "systemBlue"
    @Environment(\.colorScheme) private var colorScheme
    private var data = DataStorage()
    
    var body: some View {
        ZStack {
            Color(colorScheme == .dark ? .black : .secondarySystemBackground).ignoresSafeArea()
            VStack {
                Text("Display")
                    .font(.title3)
                    .fontWeight(.semibold)
                Text("APPEARANCE")
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
                    .padding(.top, 30)
                    .padding(.trailing, 250)
                modeAdjuster
                Text("ACCENT COLOR       ")
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
                    .padding(.top, 30)
                    .padding(.trailing, 203)
                colorChoice
                Spacer()
            }
        }
        .padding(.top, -32)
    }
    private var modeAdjuster: some View {
        HStack(spacing: 30) {
            DisplayModeAppearance(isDarkMode: $isDarkMode, modeName: Text("Light"), image: "lightMode", value: false)
            DisplayModeAppearance(isDarkMode: $isDarkMode, modeName: Text("Dark"), image: "darkMode", value: true)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(colorScheme == .dark ? Color(.secondarySystemBackground) : .white)
        )
    }
    private var colorChoice: some View {
        HStack {
            ForEach(data.accentColors) { color in
                Button {
                    accentColor = color.name
                } label: {
                    Image(systemName: accentColor == color.name ? "record.circle" : "circle.fill")
                        .foregroundStyle(color.color)
                }
            }
        }
        .padding(7)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(colorScheme == .dark ? Color(.secondarySystemBackground) : .white)
        )
        .padding(.trailing, 125)
    }
    private struct DisplayModeAppearance: View {
        @Binding var isDarkMode: Bool
        var modeName: Text
        var image: String
        var value: Bool
        var body: some View {
            VStack {
                Image(image)
                    .resizable()
                    .frame(width: 150 , height: 320)
                    .cornerRadius(20)
                modeName.padding(10)
                Button {
                    isDarkMode = value
                } label: {
                    Image(systemName: isDarkMode == value ? "checkmark.circle.fill" : "circle")
                }
            }
        }
    }
}

#Preview {
    DisplayView()
}
