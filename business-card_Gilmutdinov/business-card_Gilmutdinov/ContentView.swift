import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image("66DC70F3-F14D-47AC-9CDE-EAC2EAC733DD")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
                .clipShape(Circle())
            
            Text("Гильмутдинов Искандер")
                .font(.title2)
                .bold()
            
            Text("Kfu student")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Spacer().frame(height: 30)
            
            VStack(spacing: 15) {
                HStack {
                    Image(systemName: "phone.fill")
                        .foregroundColor(.blue)
                    Text("+7 (927) 440-27-77")
                    Spacer()
                }
                
                HStack {
                    Image(systemName: "envelope.fill")
                        .foregroundColor(.blue)
                   Text("iskander.gilmutdinov17@gmail.com")
                    Spacer()
                }
            }
            .padding()
            
            Spacer().frame(height: 30)
            
            Button(action: {
                print("Позвонить на номер")
            }) {
                Text("Позвонить")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
