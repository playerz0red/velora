//
//  File.swift
//  velora
//
//  Created by Pavel Playerz0redd on 10.07.26.
//

import Foundation

struct ResetPasswordModel {
    var email: String = ""
    var validationError: ValidationError.EmailError?
}
