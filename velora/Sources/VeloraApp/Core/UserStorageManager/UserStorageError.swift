//
//  UserStorageError.swift
//  my-bump
//
//  Created by Pavel Playerz0redd on 29.04.26.
//

import Foundation

enum UserStorageError: Error {
    case permissionDenied
    case networkError(Error)
    case unknown(Error)
    
    var message: LocalizedStringResource {
        switch self {
        case .permissionDenied:
            "Permission denied"
        case .networkError(let error):
            "Network error: \(error.localizedDescription)"
        case .unknown(let error):
            "Unknown error occured: \(error.localizedDescription)"
        }
    }
}

extension UserStorageError: Equatable {
    static func ==(lhs: UserStorageError, rhs: UserStorageError) -> Bool {
        switch lhs {
        case .permissionDenied:
            if case .permissionDenied = rhs { return true }
            
        case .networkError(let lError):
            if case .networkError(let rError) = rhs {
                return lError.localizedDescription == rError.localizedDescription
            }
        default:
            return false
        }
        return false
    }
}
