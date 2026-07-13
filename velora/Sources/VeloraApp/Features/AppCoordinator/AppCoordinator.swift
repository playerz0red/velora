import SwiftUI

@Observable
@MainActor
final class AppCoordinator {
    
    private let factory = AppFactory()
    var path = NavigationPath()
    
    func push (_ route: AppRoute) {
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

extension AppCoordinator {
    @ViewBuilder
    func destination(for route: AppRoute) -> some View {
        switch route {
        case .auth:
            AuthView(
                viewModel: factory.makeAuthViewModel()
            )
            
        case .email:
//            EmailView(
//                viewModel: factory.makeAuthViewModel()
//            )
            MainView()
            
        case .registration:
            RegistrationView(
                viewModel: factory.makeRegistrationViewModel()
            )
            
        case .home:
            Text("Home")
        }
    }
}
