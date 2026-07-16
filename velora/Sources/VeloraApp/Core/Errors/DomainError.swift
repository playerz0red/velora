//
//  File.swift
//  velora
//
//  Created by Pavel Playerz0redd on 16.07.26.
//

import Foundation

protocol DomainError: Error {
    var message: LocalizedStringResource { get }
}
