//
//  File.swift
//  velora
//
//  Created by Pavel Playerz0redd on 14.07.26.
//

import Foundation

struct IdentifiableData: Identifiable {
    let id = UUID()
    let data: Data
}

extension IdentifiableData: Equatable {
    static func ==(lhs: IdentifiableData, rhs: IdentifiableData) -> Bool {
        lhs.id == rhs.id
    }
}
