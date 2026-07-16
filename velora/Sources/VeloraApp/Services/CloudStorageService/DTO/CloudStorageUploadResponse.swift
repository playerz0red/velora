//
//  File.swift
//  velora
//
//  Created by Pavel Playerz0redd on 13.07.26.
//

import Foundation

struct CloudStorageUploadResponse: Decodable {
    let secureUrl: String
    let publicId: String
    
    enum CodingKeys: String, CodingKey {
        case secureUrl = "secure_url"
        case publicId = "public_id"
    }
}
