//
//  File.swift
//  velora
//
//  Created by Pavel Playerz0redd on 15.07.26.
//

import Foundation

@MainActor
protocol RootFactoryProtocol {
    func buildRootViewModel() -> RootViewModel
}

final class RootFactory: RootFactoryProtocol {

    private let authManager: AuthManagerProtocol
    private let userStorageManager: UserStorageManagerProtocol
    private let userSessionManager: UserSessionProtocol
    
    init(dependency: Dependency) {
        self.authManager = dependency.authManager
        self.userStorageManager = dependency.userStorageManager
        self.userSessionManager = dependency.userSessionManager
    }
    
    func buildRootViewModel() -> RootViewModel {
        let authService = AuthService(dependency: .init(
            authManager: authManager,
            userSessionManager: userSessionManager,
            userStorageManager: userStorageManager
        ))
        return RootViewModel(authService: authService)
    }
}

extension RootFactory {
    struct Dependency {
        let authManager: AuthManagerProtocol
        let userStorageManager: UserStorageManagerProtocol
        let userSessionManager: UserSessionProtocol
    }
}
