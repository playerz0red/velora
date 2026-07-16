//
//  File.swift
//  velora
//
//  Created by Pavel Playerz0redd on 13.07.26.
//

import Foundation

protocol UserFormServiceProtocol: Sendable {
    func updateUserForm(formModel: FormModel) async throws(UserFormServiceError)
}

final class UserFormService: UserFormServiceProtocol {
    
    private let userSessionManager: UserSessionProtocol
    private let userStorageManager: UserStorageManagerProtocol
    private let locationManager: LocationManagerProtocol
    private let geoDecoder: GeoDecodeServiceProtocol
    private let cloudStorageService: CloudStorageServiceProtocol
    
    init(dependency: DependencyContainer) {
        self.userSessionManager = dependency.userSessionManager
        self.userStorageManager = dependency.userStorageManager
        self.locationManager = dependency.locationManager
        self.geoDecoder = dependency.geoDecoder
        self.cloudStorageService = dependency.cloudStorageService
    }
    
    func updateUserForm(formModel: FormModel) async throws(UserFormServiceError) {
        guard let userId = userSessionManager.userId else { return }
        do {
            let imageUrls: [String] = await uploadImages(images: formModel.images)
            let location = try await locationManager.fetchLocation()
            let decodedLocation = try await geoDecoder.decode(from: location, language: "ru")
            
            let formDto: UserFormDTO = .init(
                from: formModel,
                locationDecoded: decodedLocation,
                images: imageUrls,
                location: location
            )
            
            try await userStorageManager.updateUserForm(userFormDto: formDto, userId: userId)
        } catch let error as DomainError {
            if let userStorageError = error as? UserStorageError {
                throw .uploadFormError(userStorageError)
            }
            throw .fetchInfoError(error)
        } catch {
            throw .unknown(error)
        }
    }
    
    private func uploadImages(images: [IdentifiableData]) async -> [String] {
        await withTaskGroup(of: String?.self) { group in
            images.forEach { imageData in
                group.addTask {
                    return try? await self.cloudStorageService.uploadData(data: imageData.data)
                }
            }
            
            var urls: [String] = []
            
            for await url in group {
                if let url {
                    urls.append(url)
                }
            }
            
            return urls
        }
    }
}

extension UserFormService {
    struct DependencyContainer {
        let userSessionManager: UserSessionProtocol
        let userStorageManager: UserStorageManagerProtocol
        let locationManager: LocationManagerProtocol
        let geoDecoder: GeoDecodeServiceProtocol
        let cloudStorageService: CloudStorageServiceProtocol
    }
}
