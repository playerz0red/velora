import SwiftUI

@Observable
@MainActor
final class AuthCoordinator {
    
    var path = NavigationPath()
    
    private let authFactory: AuthFactoryProtocol
    
    init(authFactory: AuthFactoryProtocol) {
        self.authFactory = authFactory
    }
    
    func push (_ route: AuthRoute) {
        path.append(route)
    }
    
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    func popToRoot() {
        path = NavigationPath()
    }
}

extension AuthCoordinator {
    @ViewBuilder
    func destination(for route: AuthRoute) -> some View {
        switch route {
        case .auth:
            AuthView(
                viewModel: authFactory.buildAuthViewModel()
            )
            
        case .email:
            EmailView(
                viewModel: authFactory.buildAuthViewModel()
            )
            
        case .registration:
            RegistrationView(
                viewModel: authFactory.buildRegistrationViewModel()
            )
            
        case .home:
            Text("Home")
        }
    }
}
