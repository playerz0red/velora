//
//  File.swift
//  velora
//
//  Created by Pavel Playerz0redd on 16.07.26.
//

import Foundation

enum GeoDecodeServiceError: DomainError {
    case decodeError(NetworkManagerError)
    
    var message: LocalizedStringResource {
        switch self {
        case .decodeError(let networkManagerError):
            "Decode location error \(networkManagerError.message)"
        }
    }
}
