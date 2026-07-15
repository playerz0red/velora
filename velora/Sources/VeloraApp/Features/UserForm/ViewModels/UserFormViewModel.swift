//
//  File.swift
//  velora
//
//  Created by Pavel Playerz0redd on 13.07.26.
//

import Foundation
import Observation

@MainActor @Observable
final class UserFormViewModel {
    
    var formModel: FormModel = .init()
    var isShowingPhotoPicker: Bool = false
    var ageError: Bool = false
    
    private let formUploader: UserFormServiceProtocol
    
    init(formUploader: UserFormServiceProtocol) {
        self.formUploader = formUploader
    }
    
    func uploadForm() {
        ageError = false
        
        guard formModel.birthday.isAdult else {
            ageError = true
            return
        }
        
        Task {
            do {
                try await self.formUploader.updateUserForm(formModel: formModel)
            } catch {
                
            }
        }
    }
}
