//
//  File.swift
//  velora
//
//  Created by Pavel Playerz0redd on 13.07.26.
//

import Foundation

enum NetworkManagerError: Error {
    case urlError
    case dataError
    case serverError(code: Int)
    case networkError
    case unknown(Error)
}
