//
//  UserStorageManager.swift
//  my-bump
//
//  Created by Pavel Playerz0redd on 29.04.26.
//

import Foundation
import SkipFirebaseFirestore

protocol UserStorageManagerProtocol: Sendable {
    func createUserProfile(name: String?, lastName: String?, email: String?, id: String) async throws(UserStorageError)
    func addUserAvatar(forUserId: String, avatarId: String) async throws(UserStorageError)
    func getUserAvatarPath(forUserId id: String) async throws(UserStorageError) -> [String]?
    func getUser(with id: String) async -> UserDTO?
    func updateUserForm(userFormDto: UserFormDTO, userId: String) async throws
}

final class UserStorageManager: UserStorageManagerProtocol {
    
    private let database = Firestore.firestore()
    
    func updateUserForm(userFormDto: UserFormDTO, userId: String) async throws {
        let data: [String: Any] = [
            FirestoreFields.UserFields.education.rawValue: userFormDto.education,
            FirestoreFields.UserFields.description.rawValue: userFormDto.description,
            FirestoreFields.UserFields.birthday.rawValue: userFormDto.birthday,
            FirestoreFields.UserFields.gender.rawValue: userFormDto.gender,
            FirestoreFields.UserFields.interests.rawValue: userFormDto.interests,
            FirestoreFields.UserFields.location.rawValue: userFormDto.location,
            FirestoreFields.UserFields.longitude.rawValue: userFormDto.latitude,
            FirestoreFields.UserFields.latitude.rawValue: userFormDto.longitude,
        ]
        
        for image in userFormDto.images {
            try await addUserAvatar(forUserId: userId, avatarId: image)
        }
        
        do {
            try await database.collection(FirestoreCollections.users.rawValue).document(userId).updateData(data)
        } catch let error {
            throw castFirestoreError(error)
        }
    }
    
    func getUser(with id: String) async -> UserDTO? {
        try? await database.collection(FirestoreCollections.users.rawValue).document(id).getDocument(as: UserDTO.self)
    }
    
    func createUserProfile(name: String?, lastName: String?, email: String?, id: String) async throws(UserStorageError) {
        let data: [String: Any] = [
            FirestoreFields.UserFields.id.rawValue: id,
            FirestoreFields.UserFields.name.rawValue: name,
            FirestoreFields.UserFields.email.rawValue: email,
            FirestoreFields.UserFields.lastName.rawValue: lastName,
            FirestoreFields.UserFields.createdAt.rawValue: FieldValue.serverTimestamp()
        ]
        do {
            try await database.collection(FirestoreCollections.users.rawValue).document(id).setData(data)
        } catch let error {
            throw castFirestoreError(error)
        }
    }
    
    func getUserAvatarPath(forUserId id: String) async throws(UserStorageError) -> [String]? {
        do {
            let document = try await database.collection(FirestoreCollections.users.rawValue).document(id).getDocument()
            return document.get(FirestoreFields.UserFields.images.rawValue) as? [String]
        } catch let error {
            throw castFirestoreError(error)
        }
    }
    
    func addUserAvatar(forUserId id: String, avatarId: String) async throws(UserStorageError) {
        let data: [String: Any] = [FirestoreFields.UserFields.images.rawValue: FieldValue.arrayUnion([avatarId])]
        do {
            try await database.collection(FirestoreCollections.users.rawValue).document(id).updateData(data)
        } catch let error {
            throw castFirestoreError(error)
        }
    }
    
    private func castFirestoreError(_ error: Error) -> UserStorageError {
        let nsError = error as NSError
        
        guard nsError.domain == FirestoreErrorDomain else { return .unknown(error) }
        
        let code = FirestoreErrorCode(_nsError: nsError).code
        
        switch code {
        case FirestoreErrorCode.permissionDenied:
            return .permissionDenied
        case FirestoreErrorCode.unavailable:
            return .networkError(error)
        default:
            return .unknown(error)
        }
    }
}
