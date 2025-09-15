import SwiftUI

struct ContentView: View {
    @Environment(\.horizontalSizeClass) private var hSizeClass
    @State private var colorSchemeOverride: ColorScheme? = nil

    private let name = "Иван Иванов"
    private let jobTitleKey: LocalizedStringKey = "job_title"
    private let phone = "+7 999 123-45-67"
    private let email = "ivan@example.com"

    private var shareText: String {
        let job = NSLocalizedString("job_title", comment: "")
        let phoneLabel = NSLocalizedString("phone_label", comment: "")
        let emailLabel = NSLocalizedString("email_label", comment: "")
        
        return """
        \(name)
        \(job)
        \(phoneLabel): \(phone)
        \(emailLabel): \(email)
        """
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Group {
                    if hSizeClass == .regular {
                        HStack(spacing: 24) {
                            avatar
                            info
                        }
                    } else {
                        VStack(spacing: 16) {
                            avatar
                            info
                        }
                    }
                }
                .frame(maxWidth: 600)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(.secondarySystemBackground))
                )
                .padding()
                
                Button {
                    if colorSchemeOverride == .dark {
                        colorSchemeOverride = .light
                    } else {
                        colorSchemeOverride = .dark
                    }
                } label: {
                    Label("Сменить тему", systemImage: "paintbrush")
                }
                .buttonStyle(.bordered)
                
            }
            .padding(.vertical)
        }
        .tint(.accentColor)
        .preferredColorScheme(colorSchemeOverride)
    }

    // Фото (Base)
    private var avatar: some View {
        Image("avatar")
            .resizable()
            .scaledToFill()
            .frame(width: 140, height: 140)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.accentColor, lineWidth: 4))
            .shadow(radius: 6)
            .padding(.top, hSizeClass == .regular ? 0 : 20)
    }

    private var info: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(name)
                .font(.title)
                .fontWeight(.semibold)
            Text(jobTitleKey)
                .foregroundColor(.secondary)

            Divider()

            ContactRow(icon: "phone.fill", titleKey: "phone_label", value: phone)
            ContactRow(icon: "envelope.fill", titleKey: "email_label", value: email)

            HStack(spacing: 12) {
                Button {
                    print("Call: \(phone)")
                } label: {
                    Label("call_button", systemImage: "phone")
                }
                .buttonStyle(.borderedProminent)

                ShareLink(item: shareText) {
                    Label("share_button", systemImage: "square.and.arrow.up")
                }
                .buttonStyle(.bordered)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.top, 8)
        }
        .padding()
    }
}

struct ContactRow: View {
    let icon: String
    let titleKey: LocalizedStringKey
    let value: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .frame(width: 20)
                .foregroundColor(.accentColor)
            VStack(alignment: .leading, spacing: 2) {
                Text(titleKey)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.body)
            }
            Spacer()
        }
    }
}


#Preview {
    Group {
        ContentView()
            .previewDisplayName("Светлая тема")
    }
}


@main
struct BusinessCardApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
