import Foundation
import Observation

@Observable
@MainActor
final class RegisterViewModel {
    
    var model: RegisterModel = .init()

    var validationResult: RegistrationValidationResult?

    var error: AuthServiceError?

    var isLoading = false

    private let authService: AuthServiceProtocol
    private let validationService: ValidationServiceProtocol

    init(
        authService: AuthServiceProtocol,
        validationService: ValidationServiceProtocol
    ) {
        self.authService = authService
        self.validationService = validationService
    }
    
    func loginWithGoogle() {
        Task {
            do {
                try await authService.signWithGoogle()
            } catch let error as AuthServiceError {
                self.error = error
            }
        }
    }
    
    func loginWithApple() {
        Task {
            do {
                try await authService.signWithApple()
            } catch let error as AuthServiceError {
                self.error = error
            }
        }
    }

    func register() {

        validationResult = validationService.validateRegister(
            registerForm: model
        )

        guard validationResult?.isValid == true else { return }

        Task {
            await registerUser()
        }
    }

    private func registerUser() async {

        isLoading = true
        defer { isLoading = false }

        do {
            try await authService.signUp(
                name: model.name,
                lastName: model.lastName,
                email: model.email,
                password: model.password
            )
        } catch {
            self.error = error
        }
    }
}
