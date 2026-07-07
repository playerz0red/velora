import SwiftUI

struct EmailView: View {
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        ZStack {
            background

            VStack(spacing: 10) {
                Spacer()
                    .frame(height: 20)

                logoBlock

                Spacer()
                
                fieldBlock

                Spacer()
            }
            .padding(.horizontal, 28)
        }
    }

    private var background: some View {
        LinearGradient(
            colors: [
                Color(red: 1.0, green: 0.95, blue: 0.98),
                Color.white
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }

    private var logoBlock: some View {
        VStack(spacing: 12) {
            Image(systemName: "heart.fill")
                .font(.system(size: 34))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.pink, Color(red: 0.95, green: 0.68, blue: 0.85)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            Text("Вход в аккаунт")
                .font(.system(size: 34, weight: .bold))
                .foregroundStyle(.black)

            Text("Введите email и пароль,\nчтобы продолжить")
                .font(.system(size: 16))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
    }

    private var fieldBlock: some View {
        VStack(spacing: 24) {
            AuthTextField(
                title: "Email",
                placeholder: "Введите email",
                icon: "envelope",
                text: $email
            )
            
            AuthTextField(
                title: "Пароль",
                placeholder: "Введите пароль",
                icon: "lock",
                isSecure: true,
                text: $password
            )
            
            EmailButton(
                title: "Войти",
                icon: "",
            )
            
            HStack(spacing: 5){
                Rectangle()
                    .fill(Color.gray.opacity(0.22))
                    .frame(height: 1)
                
                Text("или")
                    .font(.system(size: 18))
                    .foregroundStyle(.secondary)
                
                Rectangle()
                    .fill(Color.gray.opacity(0.22))
                    .frame(height: 1)
                
            }
            
            EmailButton(
                title: "Продолжить с Google",
                icon: "globe.americas.fill",
            )
            
            EmailButton(
                title: "Продолжить с Apple",
                icon: "apple.logo",
            )
            
            HStack(spacing: 6) {
                Text("Нет аккаунта?")
                    .foregroundStyle(.secondary)
                
                Button {
                } label: {
                    Text("Зарегистрироваться")
                        .fontWeight(.semibold)
                        .foregroundStyle(.pink)
                }
            }
            .font(.system(size: 16))
            .padding(.top, 4)
        }
    }

    struct AuthTextField: View {
        let title: String
        let placeholder: String
        let icon: String
        var isSecure: Bool = false
        
        @Binding var text: String
        @State private var isPasswordVisible = false
        
        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                Text(title)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(.black)
                
                HStack(spacing: 14) {
                    Image(systemName: icon)
                        .font(.system(size: 22))
                        .foregroundStyle(.gray)
                    
                    if isSecure && !isPasswordVisible {
                        SecureField(placeholder, text: $text)
                            .font(.system(size: 20))
                    } else {
                        TextField(placeholder, text: $text)
                            .font(.system(size: 20))
                            .keyboardType(isSecure ? .default : .emailAddress)
                            .autocorrectionDisabled()
                    }
                    
                    if isSecure {
                        Button {
                            isPasswordVisible.toggle()
                        } label: {
                            Image(systemName: isPasswordVisible ? "eye" : "eye.slash")
                                .font(.system(size: 22))
                                .foregroundStyle(.gray)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 20)
                .frame(height: 64)
                .background(Color.white.opacity(0.8))
                .overlay {
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .stroke(Color.gray.opacity(0.18), lineWidth: 1.2)
                }
                .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
            }
        }
    }
    
    struct EmailButton: View {
        let title: String
        var icon: String? = nil
        
        var body: some View {
            Button {
                
            } label: {
                HStack(spacing: 12) {
                    if let icon {
                        Image(systemName: icon)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.black)
                    }
                    
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.black)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(
                    LinearGradient(
                        colors: [.clear, Color(red: 0.95, green: 0.09, blue: 0.5)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay {
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(Color.black.opacity(0.48), lineWidth: 1)
                }
                .shadow(color: .black.opacity(0.04), radius: 10, x: 0, y: 4)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    EmailView()
}
