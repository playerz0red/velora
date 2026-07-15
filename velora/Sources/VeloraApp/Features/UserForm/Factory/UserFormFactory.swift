//
//  File.swift
//  velora
//
//  Created by Pavel Playerz0redd on 15.07.26.
//

import Foundation

@MainActor
protocol UserFormFactoryProtocol {
    func buildUserFormViewModel() -> UserFormViewModel
}

final class UserFormFactory: UserFormFactoryProtocol {
    
    private let userSessionManager: UserSessionProtocol
    private let userStorageManager: UserStorageManagerProtocol
    private let locationManager: LocationManagerProtocol
    private let geoDecoderManager: GeoDecodeServiceProtocol
    private let networkManager: NetworkManagerProtocol
    private let codingManager: CodingManagerProtocol
    
    init(dependency: Dependency) {
        userSessionManager = dependency.userSessionManager
        userStorageManager = dependency.userStorageManager
        locationManager = dependency.locationManager
        networkManager = dependency.networkManager
        codingManager = dependency.codingManager
        geoDecoderManager = GeoDecodeService(networkManager: networkManager, coder: codingManager)
    }
    
    func buildUserFormViewModel() -> UserFormViewModel {
        let cloudStorageService = CloudStorageService(networkManager: networkManager, coder: codingManager)
        let formUploader = UserFormService(dependency: .init(
            userSessionManager: userSessionManager,
            userStorageManager: userStorageManager,
            locationManager: locationManager,
            geoDecoder: geoDecoderManager,
            cloudStorageService: cloudStorageService
        ))
        return UserFormViewModel(formUploader: formUploader)
    }
}

extension UserFormFactory {
    struct Dependency {
        let userSessionManager: UserSessionProtocol
        let userStorageManager: UserStorageManagerProtocol
        let locationManager: LocationManagerProtocol
        let networkManager: NetworkManagerProtocol
        let codingManager: CodingManagerProtocol
    }
}
