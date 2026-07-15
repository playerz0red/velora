//
//  File.swift
//  velora
//
//  Created by Pavel Playerz0redd on 15.07.26.
//

import Foundation

@MainActor
protocol AuthFactoryProtocol {
    func buildAuthViewModel() -> AuthViewModel
    func buildRegistrationViewModel() -> RegisterViewModel
}

final class AuthFactory: AuthFactoryProtocol {
    
    private let authManager: AuthManagerProtocol
    private let userStorageManager: UserStorageManagerProtocol
    private let validationService: ValidationServiceProtocol
    
    init(dependency: Dependency) {
        self.authManager = dependency.authManager
        self.userStorageManager = dependency.userStorageManager
        self.validationService = dependency.validationService
    }
    
    func buildAuthViewModel() -> AuthViewModel {
        let authService = AuthService(authManager: authManager, userStorageManager: userStorageManager)
        return AuthViewModel(authService: authService, validationService: validationService)
    }
    
    func buildRegistrationViewModel() -> RegisterViewModel {
        let authService = AuthService(authManager: authManager, userStorageManager: userStorageManager)
        return RegisterViewModel(authService: authService, validationService: validationService)
    }
}

extension AuthFactory {
    struct Dependency {
        let authManager: AuthManagerProtocol
        let userStorageManager: UserStorageManagerProtocol
        let validationService: ValidationServiceProtocol
    }
}
