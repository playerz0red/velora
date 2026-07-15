//
//  File.swift
//  velora
//
//  Created by Pavel Playerz0redd on 13.07.26.
//

import Foundation

protocol GeoDecodeServiceProtocol: Sendable {
    func decode(from location: LocationModel, language: String) async throws -> String?
}

final class GeoDecodeService: GeoDecodeServiceProtocol {
    
    private let networkManager: NetworkManagerProtocol
    private let coder: CodingManagerProtocol
    
    init(networkManager: NetworkManagerProtocol, coder: CodingManagerProtocol) {
        self.networkManager = networkManager
        self.coder = coder
    }
    
    func decode(from location: LocationModel, language: String) async throws -> String? {
        let endpoint = GeoDecoderEndpoints.openStreetMap(location: location, language: language)
        
        let data = try await networkManager.sendRequest(endpoint: endpoint, body: nil)
        let response: GeoDecoderResponse? = coder.decode(from: data)
        
        return response?.address.cityName
    }
}

