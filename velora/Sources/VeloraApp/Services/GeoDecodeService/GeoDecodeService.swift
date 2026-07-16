//
//  File.swift
//  velora
//
//  Created by Pavel Playerz0redd on 13.07.26.
//

import Foundation

protocol GeoDecodeServiceProtocol: Sendable {
    func decode(from location: LocationModel, language: String) async throws(GeoDecodeServiceError) -> String?
}

final class GeoDecodeService: GeoDecodeServiceProtocol {
    
    private let networkManager: NetworkManagerProtocol
    private let coder: CodingManagerProtocol
    
    init(networkManager: NetworkManagerProtocol, coder: CodingManagerProtocol) {
        self.networkManager = networkManager
        self.coder = coder
    }
    
    func decode(from location: LocationModel, language: String) async throws(GeoDecodeServiceError) -> String? {
        let endpoint = GeoDecoderEndpoints.openStreetMap(location: location, language: language)
        
        do {
            let data = try await networkManager.sendRequest(endpoint: endpoint, body: nil)
            let response: GeoDecoderResponse? = coder.decode(from: data)
            
            return response?.address.cityName
        } catch {
            throw .decodeError(error)
        }
    }
}

