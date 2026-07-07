import SwiftUI

struct RegistrationView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var firstName = ""
    @State private var LastName = ""
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
                text: $LastName
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
            
            HStack(spacing: 6) {
                Text("Есть аккаунт?")
                    .foregroundStyle(.secondary)
                
                Button {
                } label: {
                    Text("Войти")
                        .fontWeight(.semibold)
                        .foregroundStyle(.pink)
                }
            }
            .font(.system(size: 16))
            .padding(.top, 4)
        }
    }
}

#Preview {
    RegistrationView()
}
