//
//  File.swift
//  velora
//
//  Created by Pavel Playerz0redd on 15.07.26.
//

import Foundation

@MainActor
final class AppDependencyContainer {
    private lazy var authManager: AuthManagerProtocol = FirebaseAuthManager()
    private lazy var userSessionManager: UserSessionProtocol = FirebaseAuthManager()
    private lazy var codingManager: CodingManagerProtocol = CodingManager()
    private lazy var locationManager: LocationManagerProtocol = LocationManager()
    private lazy var networkManager: NetworkManagerProtocol = NetworkManager()
    private lazy var userStorageManager: UserStorageManagerProtocol = UserStorageManager()
    private lazy var validationService: ValidationServiceProtocol = ValidationService()
}

extension AppDependencyContainer {
    func makeAuthFactory() -> AuthFactoryProtocol {
        AuthFactory(dependency: .init(authManager: authManager, userStorageManager: userStorageManager, validationService: validationService))
    }
}

extension AppDependencyContainer {
    func makeUserFormFactory() -> UserFormFactoryProtocol {
        UserFormFactory(dependency: .init(
            userSessionManager: userSessionManager,
            userStorageManager: userStorageManager,
            locationManager: locationManager,
            networkManager: networkManager,
            codingManager: codingManager
        ))
    }
}

extension AppDependencyContainer {
    func makeRootFactory() -> RootFactoryProtocol {
        RootFactory(authManager: authManager, userStorageManager: userStorageManager)
    }
}
