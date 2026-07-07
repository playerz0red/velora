//
//  File.swift
//  velora
//
//  Created by Pavel Playerz0redd on 6.07.26.
//

import Foundation
import Observation

@Observable @MainActor
final class AuthViewModel {
    
    var model: AuthModel = .init()
    var validationResult: LoginValidationResult?
    var error: AuthServiceError?
    
    private let authService: AuthServiceProtocol
    private let validationService: ValidationServiceProtocol
    
    init(authService: AuthServiceProtocol, validationService: ValidationServiceProtocol) {
        self.authService = authService
        self.validationService = validationService
    }
    
    func loginByCredendtials() {
        validationResult = validationService.validateLogin(loginForm: model)
        guard validationResult?.isValid == true else { return }
        
        Task {
            do {
                try await authService.signIn(email: model.email, password: model.password)
            } catch error as AuthServiceError {
                self.error = error
            }
        }
    }
    
    
}
