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
    
    init(authManager: AuthManagerProtocol, userStorageManager: UserStorageManagerProtocol) {
        self.authManager = authManager
        self.userStorageManager = userStorageManager
    }
    
    func buildRootViewModel() -> RootViewModel {
        let authService = AuthService(authManager: authManager, userStorageManager: userStorageManager)
        return RootViewModel(authService: authService)
    }
}
