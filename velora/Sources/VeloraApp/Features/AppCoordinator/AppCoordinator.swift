import SwiftUI

@Observable

final class AppCoordinator {
    
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
            AuthView()
            
        case .email:
            EmailView()
            
        case .registration:
            Text("Registration")
            
        case .home:
            Text("Home")
        }
    }
}
