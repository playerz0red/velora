//
//  File.swift
//  velora
//
//  Created by Pavel Playerz0redd on 13.07.26.
//

import Foundation

protocol CodingManagerProtocol: Sendable {
    func decode<Into: Decodable>(from data: Data) -> Into?
    func encode<From: Encodable>(from data: From) -> Data?
}

final class CodingManager: CodingManagerProtocol {
    
    private let decoder: JSONDecoder = .init()
    private let encoder: JSONEncoder = .init()
    
    func decode<Into: Decodable>(from data: Data) -> Into? {
        try? decoder.decode(Into.self, from: data)
    }
    
    func encode<From: Encodable>(from data: From) -> Data? {
        try? encoder.encode(data)
    }
}
