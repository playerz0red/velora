//
//  File 2.swift
//  velora
//
//  Created by Pavel Playerz0redd on 13.07.26.
//

import Foundation

struct GeoDecoderResponse: Decodable {
    let address: AddressData
    
    struct AddressData: Decodable {
        let town: String?
        let country: String?
        let state: String?
        
        var cityName: String? {
            town ?? state ?? country
        }
    }
}
