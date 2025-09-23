import SwiftUI

struct ContentView: View {
    @State private var isDarkMode = false
    @State private var accentColor = Color.blue
    @State private var isRussian = true
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    isRussian.toggle()
                } label: {
                    Image(systemName: "globe")
                        .font(.title2)
                }
                
                Spacer()
                
                ShareLink(item: shareableContent()) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.title2)
                }
                
                Button {
                    isDarkMode.toggle()
                } label: {
                    Image(systemName: isDarkMode ? "sun.max.fill" : "moon.fill")
                        .font(.title2)
                }
            }
            .padding()
            
            VStack {
                Image("avatar")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .foregroundColor(accentColor)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(accentColor, lineWidth: 4))
                
                Text(isRussian ? "Гусманов Илья" : "Gusmanov Ilya")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text(isRussian ? "Студент КФУ" : "KFU student")
                    .font(.title2)
                    .foregroundColor(.secondary)
            }
            .padding()
            
            Divider()
            
            VStack(spacing: 20) {
                ContactRow(icon: "phone.fill",
                          text: "+7 999 999 999",
                          accentColor: accentColor)
                
                ContactRow(icon: "envelope.fill",
                          text: "gusmanov@example.com",
                          accentColor: accentColor)
                
                Button(action: {
                    print(isRussian ? "Вызов номера: +7 999 999 999" : "Calling: +7 999 999 999")
                }) {
                    HStack {
                        Image(systemName: "phone.fill")
                        Text(isRussian ? "Позвонить" : "Call")
                    }
                    .frame(maxWidth: 100)
                    .padding()
                    .background(accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding(.horizontal)
                
                VStack {
                    Text(isRussian ? "Выберите цвет акцента" : "Choose accent color")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 15) {
                        ColorButton(color: .blue, currentColor: $accentColor)
                        ColorButton(color: .green, currentColor: $accentColor)
                        ColorButton(color: .orange, currentColor: $accentColor)
                        ColorButton(color: .purple, currentColor: $accentColor)
                        ColorButton(color: .pink, currentColor: $accentColor)
                    }
                }
                .padding()
            }
            .padding()
            
            Spacer()
        }
        .background(isDarkMode ? Color.black : Color.white)
        .foregroundColor(isDarkMode ? .white : .black)
        .environment(\.colorScheme, isDarkMode ? .dark : .light)
    }
    
    private func shareableContent() -> String {
        let name = isRussian ? "Гусманов Илья" : "Gusmanov Ilya"
        let title = isRussian ? "Студент КФУ" : "KFU student"
        let phone = "+7 999 999 999"
        let email = "gusmanov@example.com"
        
        return """
        \(name)
        \(title)
        \(isRussian ? "Телефон" : "Phone"): \(phone)
        Email: \(email)
        \(isRussian ? "Визитка создана в приложении" : "Business card created in the app")
        """
    }
}

struct ContactRow: View {
    let icon: String
    let text: String
    let accentColor: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(accentColor)
                .frame(width: 20)
            Text(text)
                .foregroundColor(accentColor)
            Spacer()
        }
        .padding(.horizontal)
    }
}

struct ColorButton: View {
    let color: Color
    @Binding var currentColor: Color
    
    var body: some View {
        Button(action: {
            currentColor = color
        }) {
            Circle()
                .fill(color)
                .frame(width: 30, height: 30)
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: currentColor == color ? 3 : 0)
                )
                .shadow(radius: 2)
        }
    }
}

#Preview {
    ContentView()
}
