//
//  File.swift
//  velora
//
//  Created by Pavel Playerz0redd on 13.07.26.
//

import Foundation
import SkipDevice
import SkipKit

protocol LocationManagerProtocol: Sendable {
    func fetchLocation() async throws(LocationManagerError) -> LocationModel
}

final class LocationManager: LocationManagerProtocol {
    
    private let provider: LocationProvider = .init()
    
    func fetchLocation() async throws(LocationManagerError) -> LocationModel {
        try await checkPermissions()
        
        do {
            let location = try await provider.fetchCurrentLocation()
            return LocationModel(latitude: location.latitude, longitude: location.longitude)
        } catch {
            throw .fetchLocationError
        }
    }
    
    private func checkPermissions() async throws(LocationManagerError) {
        guard await PermissionManager.requestLocationPermission(precise: true, always: false).isAuthorized == true else {
            throw .permissionDenied
        }
   
        guard provider.isAvailable else {
            throw .locationNotAvailable
        }
    }
    
}
