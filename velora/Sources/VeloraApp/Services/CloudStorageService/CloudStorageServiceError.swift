//
//  File.swift
//  velora
//
//  Created by Pavel Playerz0redd on 16.07.26.
//

import Foundation

enum CloudStorageServiceError: Error {
    case networkError(NetworkManagerError)
    case providerError
    case unknown(Error)
}
