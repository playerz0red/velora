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
    var serviceError: UserFormServiceError?
    let onSubmit: () -> Void
    
    private let formUploader: UserFormServiceProtocol
    
    init(formUploader: UserFormServiceProtocol, onSubmit: @escaping () -> Void) {
        self.formUploader = formUploader
        self.onSubmit = onSubmit
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
                self.onSubmit()
            } catch let error as UserFormServiceError {
                self.serviceError = error
            }
        }
    }
}
