//
//  File.swift
//  velora
//
//  Created by Pavel Playerz0redd on 15.07.26.
//

import Foundation

enum Interest: String, Decodable, CaseIterable {
    case sport
    case cinema
    case photography
    case gaming
    case travel
    case music
    case reading
    case cooking
    case art
    case gardening
    case coding
    case dancing
    
    var title: LocalizedStringResource {
        switch self {
        case .sport:
            LocalizedStringResource("Спорт")
        case .cinema:
            LocalizedStringResource("Кино")
        case .photography:
            LocalizedStringResource("Фотография")
        case .gaming:
            LocalizedStringResource("Игры")
        case .travel:
            LocalizedStringResource("Путешествия")
        case .music:
            LocalizedStringResource("Музыка")
        case .reading:
            LocalizedStringResource("Чтение")
        case .cooking:
            LocalizedStringResource("Кулинария")
        case .art:
            LocalizedStringResource("Искусство")
        case .coding:
            LocalizedStringResource("Программирование")
        case .dancing:
            LocalizedStringResource("Танцы")
        case .gardening:
            LocalizedStringResource("Садоводство")
        }
    }
