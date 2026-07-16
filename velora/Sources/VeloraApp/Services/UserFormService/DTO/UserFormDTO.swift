//
//  File.swift
//  velora
//
//  Created by Pavel Playerz0redd on 15.07.26.
//

import Foundation

struct UserFormDTO {
    let education: String
    let description: String
    let birthday: Date
    let gender: String
    let interests: [String]
    let location: String?
    let longitude: Double?
    let latitude: Double?
    let images: [String]
}

extension UserFormDTO {
    init(from model: FormModel, locationDecoded: String?, images: [String], location: LocationModel) {
        self.education = model.education
        self.description = model.description
        self.birthday = model.birthday
        self.gender = model.gender.rawValue
        self.interests = model.interests.map { $0.rawValue }
        self.location = locationDecoded
        self.longitude = location.longitude
        self.latitude = location.latitude
        self.images = images
    }
}
