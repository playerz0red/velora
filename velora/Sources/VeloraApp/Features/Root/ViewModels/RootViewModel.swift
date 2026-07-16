import Foundation
import Observation
import Combine

@MainActor @Observable
final class RootViewModel {
    
    var currentState: RootRoutes = .auth
    
    private let authService: AuthServiceProtocol
    private var cancellables: Set<AnyCancellable> = []
    
    init(authService: AuthService) {
        self.authService = authService
        setupSubscriptions()
    }
    
    func onFormSubmit() {
        currentState = .main
    }
    
    private func updateHasFilledInfo() {
        Task {
            if await authService.hasFilledInfo() {
                self.currentState = .main
            } else {
                self.currentState = .form
            }
        }
    }
    
    func signOut() {
        try? authService.signOut()
    }
    
    private func setupSubscriptions() {
        authService.signPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isSigned in
                if isSigned {
                    self?.updateHasFilledInfo()
                } else {
                    self?.currentState = .auth
                }
            }
            .store(in: &cancellables)
    }
}

