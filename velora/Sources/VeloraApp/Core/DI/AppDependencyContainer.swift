//
//  File.swift
//  velora
//
//  Created by Pavel Playerz0redd on 15.07.26.
//

import Foundation

@MainActor
final class AppDependencyContainer {
    lazy var authManager: AuthManagerProtocol = FirebaseAuthManager()
    lazy var userSessionManager: UserSessionProtocol = FirebaseAuthManager()
    lazy var codingManager: CodingManagerProtocol = CodingManager()
    lazy var locationManager: LocationManagerProtocol = LocationManager()
    lazy var networkManager: NetworkManagerProtocol = NetworkManager()
    lazy var userStorageManager: UserStorageManagerProtocol = UserStorageManager()
    lazy var validationService: ValidationServiceProtocol = ValidationService()
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
