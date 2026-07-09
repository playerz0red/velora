import Foundation

@MainActor
final class AppFactory {
    
    private lazy var authManager: AuthManagerProtocol = FirebaseAuthManager()
    private lazy var userStorageManager: UserStorageManagerProtocol = UserStorageManager()
    
    private lazy var authService: AuthServiceProtocol = AuthService (
        authManager: authManager,
        userStorageManager: userStorageManager
    )
    
    private lazy var validationService: ValidationServiceProtocol = ValidationService()
    
    func makeAuthViewModel() -> AuthViewModel {
        AuthViewModel(
            authService: authService,
            validationService: validationService
        )
    }
    
    func makeRegistrationViewModel() -> RegisterViewModel {
        RegisterViewModel(
            authService: authService,
            validationService: validationService)
    }
}
