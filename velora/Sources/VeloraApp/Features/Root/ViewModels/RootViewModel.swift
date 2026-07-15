import Foundation
import Observation
import Combine

@MainActor @Observable
final class RootViewModel {
    
    var isSigned: Bool = false
    
    private let authService: AuthService
    private var cancellables: Set<AnyCancellable> = []
    
    init(authService: AuthService) {
        self.authService = authService
        setupSubscriptions()
    }
    
    func signOut() {
        try? authService.signOut()
    }
    
    private func setupSubscriptions() {
        authService.signPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isSigned in
                self?.isSigned = isSigned
            }
            .store(in: &cancellables)
    }
}
