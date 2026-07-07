import SwiftUI

struct EmailView: View {
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        ZStack {
            AuthBackground()
            
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
        AuthLogo(
            title: "Вход в аккаунт",
            subtitle: "Введите email и пароль, чтобы продолжить"
        )
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
            
            AuthButton(
                title: "Войти",
                icon: nil,
                action: {
                }
            )
            
            AuthDivider(
                title: "или")
            
            AuthButton(
                title: "Продолжить с Google",
                icon: "globe.americas.fill",
                action: {
                }
            )
            
            AuthButton(
                title: "Продолжить с Apple",
                icon: "apple.logo",
                action: {
                }
            )
            
            AuthFooter(
                title: "Нет аккаунта?",
                buttonLabel: "Зарегистрироваться")
        }
    }
}


#Preview {
    EmailView()
}
