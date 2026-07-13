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
    var resetPasswordModel: ResetPasswordModel = .init()
    var resetPasswordError: AuthServiceError?
    
    private let authService: AuthServiceProtocol
    private let validationService: ValidationServiceProtocol
    
    init(authService: AuthServiceProtocol, validationService: ValidationServiceProtocol) {
        self.authService = authService
        self.validationService = validationService
    }
    
    func changePassword() {
        resetPasswordModel.validationError = validationService.validateEmail(resetPasswordModel.email)
        guard resetPasswordModel.validationError == nil else { return }
        
        Task {
            do {
                try await authService.changePassword(email: resetPasswordModel.email)
            } catch let error as AuthServiceError {
                self.resetPasswordError = error
            }
        }
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
