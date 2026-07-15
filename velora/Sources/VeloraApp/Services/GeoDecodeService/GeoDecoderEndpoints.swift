//
//  File 2.swift
//  velora
//
//  Created by Pavel Playerz0redd on 13.07.26.
//

import Foundation

enum GeoDecoderEndpoints: EndpointProtocol {
    case openStreetMap(location: LocationModel, language: String)
    
    var baseUrl: String {
        switch self {
        case .openStreetMap:
            "https://nominatim.openstreetmap.org/reverse"
        }
    }
    
    var httpMethod: HttpMethod {
        switch self {
        case .openStreetMap:
                .get
        }
    }
    
    var url: URL? {
        configureUrl()
    }
    
    private func configureUrl() -> URL? {
        var components: URLComponents? = .init(string: self.baseUrl)
        var queryItems: [URLQueryItem] = []
        
        switch self {
        case .openStreetMap(let location, let language):
            queryItems.append(.init(name: "format", value: "json"))
            queryItems.append(.init(name: "lat", value: "\(location.latitude)"))
            queryItems.append(.init(name: "lon", value: "\(location.longitude)"))
            queryItems.append(.init(name: "accept-language", value: language))
        }
        
        components?.queryItems = queryItems
        return components?.url
    }
    
    
}
