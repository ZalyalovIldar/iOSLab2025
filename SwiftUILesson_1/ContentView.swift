import SwiftUI

struct ContentView: View {
    @AppStorage("isDarkMode") var isDarkMode = false
    @State private var isSharePresented = false
    @State private var isRussian = true

    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    Image("azamat")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .clipShape(.rect(cornerRadius: 45))
                        .shadow(radius: 10)
                    
                    Text("Azamat Zakirov")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(10)
                        
                    Text("iOS Developer")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                }
                .padding(.top, 20)
                
                Divider()
                    .padding(30)
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "phone.fill")
                        Text("+(7) 917 261 95 47")
                    }
                    HStack {
                        Image(systemName: "envelope.fill")
                        Text("zakirovazamat0508@gmail.com")
                    }
                }
                .font(.headline)
                .padding()
                
                Spacer()
            
                HStack(spacing: 20) {
                    Button(action: {
                        isSharePresented = true
                    }) {
                        Text("Share")
                            .frame(maxWidth:.infinity, maxHeight: 50)
                    }
                    .buttonStyle(.bordered)
                    .tint(.indigo)
                    .clipShape(.rect(cornerRadius: 150))
                    .sheet(isPresented: $isSharePresented) {
                        ActivityView(activityItems: [
                            URL(string: "https://t.me/zakirov_azamat")!
                        ])
                    }
                    
                    Button(action: {
                        callNumber(phoneNumber: "+79172619547")
                    }) {
                        Text("Call")
                            .frame(maxWidth:.infinity, maxHeight: 50)
                    }
                    .buttonStyle(.bordered)
                    .tint(.green)
                    .clipShape(.rect(cornerRadius: 150))
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
            .preferredColorScheme(isDarkMode ? .dark : .light)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        // затычка-не смог реализовать локализацию
                    }) {
                        Image(systemName: "globe")
                            .font(.title2)
                            .foregroundStyle(.blue)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isDarkMode.toggle()
                    }) {
                        Image(systemName: isDarkMode ? "sun.max.fill" : "moon.fill")
                            .font(.title2)
                            .foregroundStyle(.orange)
                    }
                }
                
            }
        }
    }
}



func callNumber(phoneNumber : String) {
    if let phoneUrl = URL(string: "tel://\(phoneNumber)"),
       UIApplication.shared.canOpenURL(phoneUrl) {
        UIApplication.shared.open(phoneUrl)
    }
}

struct ActivityView: UIViewControllerRepresentable {
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
#Preview {
    ContentView()
}
