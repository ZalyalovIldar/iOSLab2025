import SwiftUI

struct ContentView: View {
    @State private var secretNumber = Int.random(in: 1...100)
    @State private var userGuess = ""
    @State private var message = "Угадай число от 1 до 100"
    @State private var attempts = 0
    @State private var gameOver = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Отгадай число")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 40)
            
            Text("Попыток: \(attempts)")
                .font(.title2)
                .foregroundColor(.blue)
                .padding(.bottom, 10)
            
            Text(message)
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal)
                .frame(minHeight: 80)
            
            TextField("", text: $userGuess)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .disabled(gameOver)
            
            Button(action: checkGuess) {
                Text("Проверить")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(gameOver ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .disabled(userGuess.isEmpty || gameOver)
            
            Button(action: startNewGame) {
                Text("Новая игра")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding()
    }
    
    func checkGuess() {
        guard let guess = Int(userGuess) else {
            message = "Введите число!"
            userGuess = ""
            return
        }
        
        if guess < 1 || guess > 100 {
            message = "Обратите внимание на диапазон числа"
            userGuess = ""
            return
        }
        
        attempts += 1
        
        if guess == secretNumber {
            gameOver = true
            message = "Вы выиграли за \(attempts) попыток!"
        } else if guess < secretNumber {
            message = "Больше!"
        } else {
            message = "Меньше!"
        }
        
        userGuess = ""
    }
    
    func startNewGame() {
        secretNumber = Int.random(in: 1...100)
        attempts = 0
        gameOver = false
        userGuess = ""
        message = "Угадай число от 1 до 100"
    }
}

#Preview {
    ContentView()
}
