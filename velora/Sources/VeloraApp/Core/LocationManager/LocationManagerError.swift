//
//  File.swift
//  velora
//
//  Created by Pavel Playerz0redd on 13.07.26.
//

import Foundation

enum LocationManagerError: DomainError {
    case permissionDenied
    case locationNotAvailable
    case fetchLocationError
    
    var message: LocalizedStringResource {
        switch self {
        case .permissionDenied:
            "Permission denied"
        case .locationNotAvailable:
            "Location is not available"
        case .fetchLocationError:
            "Location fetch error"
        }
    }
}
