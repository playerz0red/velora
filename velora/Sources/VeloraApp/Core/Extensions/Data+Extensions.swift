//
//  File.swift
//  velora
//
//  Created by Pavel Playerz0redd on 13.07.26.
//

import Foundation

extension Data {
    var mimeType: String {
        guard !self.isEmpty else { return "image/jpeg" }
        
        let byte = self[0]
        switch byte {
        case 0xFF:
            return "image/jpeg"
        case 0x89:
            return "image/png"
        case 0x47:
            return "image/gif"
        case 0x52:
            let subdata = self.subdata(in: 8..<12)
            if String(data: subdata, encoding: .ascii) == "WEBP" {
                return "image/webp"
            }
            return "image/jpeg"
        default:
            return "image/jpeg"
        }
    }
}
