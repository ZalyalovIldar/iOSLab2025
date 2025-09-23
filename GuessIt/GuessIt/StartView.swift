//
//  StartView.swift
//  GuessIt
//
//  Created by Artur Bagautdinov on 22.09.2025.
//
import SwiftUI

struct StartView: View {
    
    @State private var selectedDifficulty: Difficulty = .easy
    @State private var path = NavigationPath()
    @State private var minValue: Int = 1
    @State private var maxValue: Int = 100
    
    let minLimit: Int = 1
    let maxLimit: Int = 1000
    let numberRange = 1...1000
    
    var body: some View {
    
        NavigationStack(path: $path) {
            
            TitleView()
            
            Divider()
                .background(Color(.gray))
                .padding(.horizontal)
            
            VStack(spacing: 30) {
                Text("Select Difficulty")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Picker("Level", selection: $selectedDifficulty) {
                    ForEach(Difficulty.allCases) { difficulty in
                        Text(difficulty.rawValue).tag(difficulty)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
                Text("Adjust the number range")
                    .font(.headline)
                    .fontWeight(.bold)
                
                HStack(spacing: 30) {
                    
                    VStack {
                        
                        Text("Min Value")
                            .font(.subheadline)
                            .foregroundStyle(Color.blue)
                            .fontWeight(.bold)
                        
                        Picker("Min", selection: $minValue) {
                            ForEach(numberRange, id: \.self) { number in
                                Text("\(number)").tag(number)
                            }
                            
                        }
                        .pickerStyle(.wheel)
                        .frame(width: 150, height: 150)
                        .onChange(of: minValue) {
                            if minValue > maxValue {
                                minValue = maxValue - 1
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        
                    }
                    
                    VStack {
                        
                        Text("Max Value")
                            .font(.subheadline)
                            .foregroundColor(Color.blue)
                            .fontWeight(.bold)
                        
                        Picker("Max", selection: $maxValue) {
                            ForEach(numberRange, id: \.self) { number in
                                Text("\(number)").tag(number)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(width: 150, height: 150)
                        .onChange(of: maxValue) {
                            if maxValue < minValue {
                                maxValue = minValue + 1
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        
                    }
                }
                
                Divider()
                    .background(Color.gray)
                
                Button("Start game") {
                    let settings = GameSettings(maxAttempts: selectedDifficulty.attemptCount, minNumber: minValue, maxNumber: maxValue)
                    path.append(settings)
                }
                .foregroundStyle(Color.white)
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color.blue)
                        .frame(width: 200, height: 50)
                )
                    
                
                Text("Attempts: \(selectedDifficulty.attemptCount), range: from \(minValue) to \(maxValue)")
                    .foregroundStyle(Color.gray)
                    .font(.caption)
                    .fontWeight(.bold)
                
            }
            .padding(.horizontal)
            .navigationDestination(for: GameSettings.self) { settings in
                GameView(maxAttempts: settings.maxAttempts, min: settings.minNumber, max: settings.maxNumber)
            }
            
        }
    }
}

struct GameSettings: Hashable {
    let maxAttempts: Int
    let minNumber: Int
    let maxNumber: Int
}

#Preview {
    StartView()
}
