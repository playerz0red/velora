//
//  FirestoreSchema.swift
//  my-bump
//
//  Created by Pavel Playerz0redd on 9.06.26.
//

import Foundation


enum FirestoreCollections: String {
    case users = "users"
}


enum FirestoreFields {
    enum UserFields: String {
        case id = "id"
        case name = "name"
        case email = "email"
        case createdAt = "createdAt"
        case images = "images"
        case lastName = "lastName"
        case birthday = "birthday"
        case location = "location"
        case description = "description"
        case education = "education"
        case gender = "gender"
        case interests = "interests"
        case latitude = "latitude"
        case longitude = "longitude"
    }
}
