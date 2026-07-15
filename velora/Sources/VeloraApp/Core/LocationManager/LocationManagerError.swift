//
//  File.swift
//  velora
//
//  Created by Pavel Playerz0redd on 13.07.26.
//

import Foundation

enum LocationManagerError: Error {
    case permissionDenied
    case locationNotAvailable
    case fetchLocationError
}
