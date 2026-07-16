//
//  File.swift
//  velora
//
//  Created by Pavel Playerz0redd on 16.07.26.
//

import Foundation

enum UserFormServiceError: DomainError {
    case fetchInfoError(DomainError)
    case uploadFormError(DomainError)
    case unknown(Error)
    
    var message: LocalizedStringResource {
        switch self {
        case .fetchInfoError(let domainError):
            "Fetch user info error \(domainError.message)"
        case .uploadFormError(let domainError):
            "Upload form error \(domainError.message)"
        case .unknown(let error):
            "Unknown error \(error.localizedDescription)"
        }
    }
}
