//
//  AuthManagerError.swift
//  my-bump
//
//  Created by Pavel Playerz0redd on 16.04.26.
//

import Foundation

enum AuthManagerError: Error {
    case emailIsAlreadyInUse
    case userNotFound
    case missGoogleIdToken
    case userCancelledSignIn
    case invalidEmail(Error)
    case networkError(Error)
    case unknown(Error)
    
    var message: LocalizedStringResource {
        switch self {
        case .emailIsAlreadyInUse:
                "Email is already in use"
        case .userNotFound:
                "User not fount"
        case .invalidEmail(let error):
                "invalid email: \(error.localizedDescription)"
        case .networkError(let error):
                "network error: \(error.localizedDescription)"
        case .unknown(let error):
                "unknown error: \(error.localizedDescription)"
        case .missGoogleIdToken:
                "Missing google token"
        case .userCancelledSignIn:
                "User cancelled sign in"
        }
    }
}

extension AuthManagerError: Equatable {
    static func == (lhs: AuthManagerError, rhs: AuthManagerError) -> Bool {
        switch lhs {
        case .emailIsAlreadyInUse:
            if case .emailIsAlreadyInUse = rhs { return true }
        case .userNotFound:
            if case .userNotFound = rhs { return true }
        case .missGoogleIdToken:
            if case .missGoogleIdToken = rhs { return true }
        case .userCancelledSignIn:
            if case .userCancelledSignIn = rhs { return true }
            
        case .invalidEmail(let lErr):
            if case .invalidEmail(let rErr) = rhs {
                return lErr.localizedDescription == rErr.localizedDescription
            }
        case .networkError(let lErr):
            if case .networkError(let rErr) = rhs {
                return lErr.localizedDescription == rErr.localizedDescription
            }
        case .unknown(let lErr):
            if case .unknown(let rErr) = rhs {
                return lErr.localizedDescription == rErr.localizedDescription
            }
        }
        
        return false
    }
}
