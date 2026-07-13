import SwiftUI

struct EmailView: View {
    @Bindable private var viewModel: AuthViewModel
    
    @Environment(AppCoordinator.self)
    private var coordinator
    
    init(viewModel: AuthViewModel) {
        self.viewModel = viewModel
    }
    
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
                text: $viewModel.model.email
            )
            
            AuthTextField(
                title: "Пароль",
                placeholder: "Введите пароль",
                icon: "lock",
                isSecure: true,
                text: $viewModel.model.password
            )
            
            AuthButton(
                title: "Войти",
                icon: nil,
                action: viewModel.loginByCredendtials
            )
            
            AuthDivider(
                title: "или")
            
            AuthButton(
                title: "Продолжить с Google",
                icon: "globe.americas.fill",
                action: viewModel.loginWithGoogle
            )
            
            AuthButton(
                title: "Продолжить с Apple",
                icon: "apple.logo",
                action: viewModel.loginWithApple
            )
            
            AuthFooter(
                title: "Нет аккаунта?",
                buttonLabel: "Зарегистрироваться")
            {
                coordinator.push(.registration)
            }
        }
    }
}
