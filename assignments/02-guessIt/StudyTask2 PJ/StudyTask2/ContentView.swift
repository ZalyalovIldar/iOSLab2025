//
//  ContentView.swift
//  StudyTask2
//
//  Created by Иван Метальников on 22.09.2025.
//

import SwiftUI

struct ContentView: View {
    
    @State var userPrediction: String = ""
    @State var upNumberDouble: Double = 100
    @State var upNumber: Int = 100
    @State var number: Int = getRandomNumber()
    @State var gameText: String = ""
    @State var score: Int = 0
    @State var errors: Int = 0
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Угадайте число от 1 до \(upNumber)")
                .font(.title2)
                .background(Color.blue.opacity(0.2))
                .padding()
            
            Spacer()
            
            Text("Угадано: \(score)")
                .bold()
            Text("Ошибок: \(errors)")
                .bold()

            TextField("Введите ваше число", text: $userPrediction)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .padding()
                .onChange(of: userPrediction){
                    guard let userNumber = Int(userPrediction) else { return }
                    
                    if userNumber == number {
                        gameText = "Поздравляю, вы угадали! Число было изменено"
                        number = ContentView.getRandomNumber(upNumber: upNumber)
                        score += 1
                    } else if userNumber > number {
                        gameText = "Число меньше"
                        errors+=1
                    } else {
                        gameText = "Число больше"
                        errors+=1
                    }
                }
            
          
            Text(gameText)
            Spacer()
            Button("Новая игра"){
                score=0
                errors=0
                number = ContentView.getRandomNumber(upNumber: upNumber)
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 10.0))
            .padding(.bottom, 20)
            
            VStack {
                Text("Выберите максимальное число")
                Slider(value: $upNumberDouble, in: 1...100,step: 1)
                    .onChange(of: upNumberDouble){
                        upNumber = Int(upNumberDouble)
                        number = ContentView.getRandomNumber(upNumber: upNumber)
                    }
            }
            
            
        }
        .padding()
    }
    
    private static func getRandomNumber(upNumber: Int = 100) -> Int {
        return Int.random(in: 1...upNumber)
    }
}

#Preview {
    ContentView()
}
