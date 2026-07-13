import SwiftUI

struct RegistrationView: View {
    @Bindable private var viewModel: RegisterViewModel
    
    @Environment(AppCoordinator.self)
    private var coordinator
    
    init(viewModel: RegisterViewModel) {
        self.viewModel = viewModel
    }
    
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
                text: $viewModel.model.name
            )
            
            AuthTextField(
                title: "Фамилия",
                placeholder: "Фамилия",
                icon: "person",
                text: $viewModel.model.lastName
            )
            
            AuthTextField(
                title: "Email",
                placeholder: "Email",
                icon: "envelope",
                text: $viewModel.model.email
            )
            
            AuthTextField(
                title: "Введите пароль",
                placeholder: "Введите пароль",
                icon: "lock",
                isSecure: true,
                text: $viewModel.model.password
            )
            
            AuthTextField(
                title: "Подтвердите пароль",
                placeholder: "Подтвердите пароль",
                icon: "lock",
                isSecure: true,
                text: $viewModel.model.passwordConfirmation
            )
            
            AuthButton(
                title: "Зарегистрироваться",
                icon: nil,
                action: {viewModel.register()
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
            {
                coordinator.push(.email)
            }
        }
    }
}

//#Preview {
//    RegistrationView()
//}
