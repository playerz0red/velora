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
