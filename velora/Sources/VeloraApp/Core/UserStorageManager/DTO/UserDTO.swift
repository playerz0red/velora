//
//  UserDTO.swift
//  my-bump
//
//  Created by Pavel Playerz0redd on 30.04.26.
//

import Foundation

struct UserDTO: Decodable {
    let id: String
    let name: String
    let email: String
    let images: [String]?
    let birthday: Date
    let location: String?
    let description: String?
    let gender: Gender
    let interests: [Interest]?
    let education: String?
    let latitude: Double?
    let longitude: Double?
}
