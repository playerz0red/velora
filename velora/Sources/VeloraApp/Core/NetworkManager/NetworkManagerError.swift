//
//  File.swift
//  velora
//
//  Created by Pavel Playerz0redd on 13.07.26.
//

import Foundation

enum NetworkManagerError: DomainError {
    case urlError
    case dataError
    case serverError(code: Int)
    case networkError
    case unknown(Error)
    
    var message: LocalizedStringResource {
        switch self {
        case .urlError:
            "Server url error"
        case .dataError:
            "Data error"
        case .serverError(let code):
            "Server error with code: \(code)"
        case .networkError:
            "Network error"
        case .unknown(let error):
            "Unknown error occured: \(error.localizedDescription)"
        }
    }
}
