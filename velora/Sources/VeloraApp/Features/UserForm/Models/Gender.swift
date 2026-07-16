//
//  File.swift
//  velora
//
//  Created by Pavel Playerz0redd on 15.07.26.
//

import Foundation

enum Gender: String, Decodable, CaseIterable, Hashable {
    case male
    case female
    case other
    
    var title: LocalizedStringResource {
        switch self {
        case .male:
            "Мужской"
        case .female:
            "Женский"
        case .other:
            "Другой"
        }
    }
}
