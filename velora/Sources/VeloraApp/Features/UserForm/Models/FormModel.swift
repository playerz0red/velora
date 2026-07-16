//
//  File.swift
//  velora
//
//  Created by Pavel Playerz0redd on 13.07.26.
//

import Foundation

struct FormModel {
    var birthday: Date = .init()
    var gender: Gender = .male
    var description: String = ""
    var interests: [Interest] = []
    var education: String = ""
    var images: [IdentifiableData] = []
}
