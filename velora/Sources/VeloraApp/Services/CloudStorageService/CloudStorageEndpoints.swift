//
//  File.swift
//  velora
//
//  Created by Pavel Playerz0redd on 13.07.26.
//

import Foundation

enum CloudStorageEndpoints: EndpointProtocol {
    case cloudinary(cloudName: String)
    
    var httpMethod: HttpMethod {
        switch self {
        case .cloudinary:
                .post
        }
    }
    
    var baseUrl: String {
        switch self {
        case .cloudinary(let cloudName):
            "https://api.cloudinary.com/v1_1/\(cloudName)/image/upload"
        }
    }
    
    var url: URL? {
        switch self {
        case .cloudinary:
            URL(string: self.baseUrl)
        }
    }
}
