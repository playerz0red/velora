//
//  AuthError.swift
//  my-bump
//
//  Created by Pavel Playerz0redd on 16.04.26.
//

import Foundation

enum AuthServiceError: Error {
    case saveProfileError(UserStorageError)
    case loginError(AuthManagerError)
    case signOutError(AuthManagerError)
    case registerError(AuthManagerError)
    case changePasswordError(AuthManagerError)
    case unknown(Error)

    var message: LocalizedStringResource {
        switch self {
        case .saveProfileError(let error):
            error.message
        case .loginError(let authManagerError):
            authManagerError.message
        case .signOutError(let authManagerError):
            authManagerError.message
        case .registerError(let authManagerError):
            authManagerError.message
        case .changePasswordError(let authManagerError):
            authManagerError.message
        case .unknown(let error):
            "\(error.localizedDescription)"
        }
    }
}

extension AuthServiceError: Equatable {
    static func ==(lhs: AuthServiceError, rhs: AuthServiceError) -> Bool {
        switch lhs {
        case .unknown(let lError):
            if case .unknown(let rError) = rhs {
                return lError.localizedDescription == rError.localizedDescription
            }
        default:
            break
        }
        
        return lhs.message == rhs.message
    }
}
