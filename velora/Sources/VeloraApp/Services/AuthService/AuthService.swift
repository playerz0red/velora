//
//  AuthService.swift
//  my-bump
//
//  Created by Pavel Playerz0redd on 14.04.26.
//

import Foundation
import Combine

protocol AuthServiceProtocol: Sendable {
    var signPublisher: AnyPublisher<Bool, Never> { get }
    
    func hasFilledInfo() async -> Bool
    func signUp(name: String, lastName: String, email: String, password: String) async throws(AuthServiceError)
    func signIn(email: String, password: String) async throws(AuthServiceError)
    func signWithGoogle() async throws(AuthServiceError)
    func signWithApple() async throws(AuthServiceError)
    func signOut() throws(AuthServiceError)
    func changePassword(email: String) async throws(AuthServiceError)
}

final class AuthService: AuthServiceProtocol, @unchecked Sendable {
    
    private let authManager: AuthManagerProtocol
    private let userSessionManager: UserSessionProtocol
    private let userStorageManager: UserStorageManagerProtocol
    
    init(dependency: Dependency) {
        self.authManager = dependency.authManager
        self.userSessionManager = dependency.userSessionManager
        self.userStorageManager = dependency.userStorageManager
    }
    
    var signPublisher: AnyPublisher<Bool, Never> {
        authManager.isSignedPublisher
    }
    
    func hasFilledInfo() async -> Bool {
        guard let id = userSessionManager.userId else { return false }
        guard let user = await userStorageManager.getUser(with: id) else { return false }
        return true
    }
    
    func signUp(name: String, lastName: String, email: String, password: String) async throws(AuthServiceError) {
        do {
            let uid = try await authManager.signUp(username: name, email: email, password: password)
            try await userStorageManager.createUserProfile(name: name, lastName: lastName, email: email, id: uid)
        } catch let error as AuthManagerError {
            throw .registerError(error)
        } catch let error as UserStorageError {
            throw .saveProfileError(error)
        } catch let error {
            throw .unknown(error)
        }
    }
    
    func signWithGoogle() async throws(AuthServiceError) {
        do {
            if let authModel = try await authManager.signWithGoogle() {
                try await userStorageManager.createUserProfile(name: authModel.firstName, lastName: authModel.lastName, email: authModel.email, id: authModel.uid)
            }
        } catch let error as AuthManagerError {
            throw .loginError(error)
        } catch let error as UserStorageError {
            throw .saveProfileError(error)
        } catch {
            throw .unknown(error)
        }
    }
    
    func signWithApple() async throws(AuthServiceError) {
        do {
            if let authModel = try await authManager.signInWithApple() {
                try await userStorageManager.createUserProfile(name: authModel.firstName, lastName: authModel.lastName, email: authModel.email, id: authModel.uid)
            }
        } catch let error as AuthManagerError {
            throw .loginError(error)
        } catch let error as UserStorageError {
            throw .saveProfileError(error)
        } catch {
            throw .unknown(error)
        }
    }
    
    func signIn(email: String, password: String) async throws(AuthServiceError) {
        do {
            try await authManager.signIn(email: email, password: password)
        } catch let error {
            throw .loginError(error)
        }
    }
    
    func signOut() throws(AuthServiceError) {
        do {
            try authManager.signOut()
        } catch let error {
            throw .signOutError(error)
        }
    }
    
    var isSignedIn: Bool {
        authManager.isSignedIn
    }
    
    func changePassword(email: String) async throws(AuthServiceError) {
        do {
            try await authManager.changePassword(email: email)
        } catch let error {
            throw .changePasswordError(error)
        }
    }
}

extension AuthService {
    struct Dependency {
        let authManager: AuthManagerProtocol
        let userSessionManager: UserSessionProtocol
        let userStorageManager: UserStorageManagerProtocol
    }
}
