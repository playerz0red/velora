//
//  ValidationError.swift
//  my-bump
//
//  Created by Pavel Playerz0redd on 14.04.26.
//

import Foundation


protocol ValidationErrorProtocol: Error {
    var message: LocalizedStringResource { get }
}

enum ValidationError {
    
    enum NameError: Equatable, ValidationErrorProtocol {
        case tooShort
        case tooLong
        case empty
        
        var message: LocalizedStringResource {
            switch self {
            case .tooShort:
                    "Name is too short"
            case .tooLong:
                    "Name is too long"
            case .empty:
                    "Name is empty"
            }
        }
    }
    
    enum EmailError: Equatable, ValidationErrorProtocol {
        case invalidFormat
        case empty
        case tooLong
        
        var message: LocalizedStringResource {
            switch self {
            case .invalidFormat:
                    "Email has invalid format"
            case .empty:
                    "Email is empty"
            case .tooLong:
                    "Email is too long"
            }
            
        }
    }
    
    enum PasswordError: Equatable, ValidationErrorProtocol {
        case passwordMismatch
        case tooShort
        case tooLong
        case empty
        
        var message: LocalizedStringResource {
            switch self {
            case .passwordMismatch:
                    "Passwords are not equal"
            case .tooShort:
                    "Password is too short"
            case .tooLong:
                    "Password is too long"
            case .empty:
                    "Password is empty"
            }
        }
    }
}
