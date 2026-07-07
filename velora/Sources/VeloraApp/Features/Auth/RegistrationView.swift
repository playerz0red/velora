import SwiftUI

struct RegistrationView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var confirmPassword = ""
    
    var body: some View {
        ZStack {
            AuthBackground()
            
            VStack(spacing: 10) {
                Spacer()
                    .frame(height: 10)
                
                logoBlock
                
                Spacer()
                
                fieldBlock
                
                Spacer()
            }
            .padding(.horizontal, 28)
        }
    }
    
    private var logoBlock: some View {
        AuthLogo(
            title: "Регистрация",
            subtitle: "Создай аккаунт и начни свою историю"
        )
    }
    
    private var fieldBlock: some View {
        VStack(spacing: 10) {
            AuthTextField(
                title: "Имя",
                placeholder: "Имя",
                icon: "person",
                text: $firstName
            )
            
            AuthTextField(
                title: "Фамилия",
                placeholder: "Фамилия",
                icon: "person",
                text: $lastName
            )
            
            AuthTextField(
                title: "Email",
                placeholder: "Email",
                icon: "envelope",
                text: $email
            )
            
            AuthTextField(
                title: "Введите пароль",
                placeholder: "Введите пароль",
                icon: "lock",
                isSecure: true,
                text: $password
            )
            
            AuthTextField(
                title: "Подтвердите пароль",
                placeholder: "Подтвердите пароль",
                icon: "lock",
                isSecure: true,
                text: $password
            )
            
            AuthButton(
                title: "Зарегистрироваться",
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
                title: "Есть аккаунт?",
                buttonLabel: "Войти")
        }
    }
}

#Preview {
    RegistrationView()
}
