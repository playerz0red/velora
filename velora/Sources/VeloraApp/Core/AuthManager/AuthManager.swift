//
//  AuthManager.swift
//  my-bump
//
//  Created by Pavel Playerz0redd on 16.04.26.
//

import Foundation
import SkipFirebaseAuth
import Combine
import SkipFirebaseCore

#if os(iOS)
import AuthenticationServices
import GoogleSignIn
#endif

protocol AuthManagerProtocol: Sendable {
    var isSignedPublisher: AnyPublisher<Bool, Never> { get }
    var isSignedIn: Bool { get }
    
    func signUp(username: String, email: String, password: String) async throws(AuthManagerError) -> String
    func signIn(email: String, password: String) async throws(AuthManagerError)
    func signOut() throws(AuthManagerError)
    func changePassword(email: String) async throws(AuthManagerError)
    func signInWithApple() async throws(AuthManagerError) -> AuthUserModel?
    func signWithGoogle() async throws(AuthManagerError) -> AuthUserModel?
}

protocol UserSessionProtocol: Sendable {
    var userId: String? { get }
    var username: String? { get }
    
    func signOut() throws(AuthManagerError)
}

final class FirebaseAuthManager: AuthManagerProtocol, UserSessionProtocol, @unchecked Sendable  {
    
    var username: String? {
        Auth.auth().currentUser?.displayName
    }
    
    var userId: String? {
        Auth.auth().currentUser?.uid
    }
    
    var isSignedPublisher: AnyPublisher<Bool, Never> {
        signSubject.eraseToAnyPublisher()
    }
    
    var isSignedIn: Bool {
        Auth.auth().currentUser != nil
    }
    
    private var signSubject = PassthroughSubject<Bool, Never>()
    private nonisolated(unsafe) var handle: AuthStateDidChangeListenerHandle?
    
    init() {
        listenToAuthState()
    }
    
    deinit {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    func signUp(username: String, email: String, password: String) async throws(AuthManagerError) -> String {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            
            let changeRequest = result.user.createProfileChangeRequest()
            changeRequest.displayName = username
            
            try await changeRequest.commitChanges()
            
            return result.user.uid
        } catch let error {
            throw castFirebaseError(error)
        }
    }
    
    func signIn(email: String, password: String) async throws(AuthManagerError) {
        do {
            try await Auth.auth().signIn(withEmail: email, password: password)
        } catch let error {
            throw castFirebaseError(error)
        }
    }
    
    func signOut() throws(AuthManagerError) {
        do {
            try Auth.auth().signOut()
        } catch let error {
            throw castFirebaseError(error)
        }
    }
    
    func changePassword(email: String) async throws(AuthManagerError) {
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
        } catch let error {
            throw castFirebaseError(error)
        }
    }
    
    func signWithGoogle() async throws(AuthManagerError) -> AuthUserModel? {
        #if skip
        // Логика для Android (пока можно оставить пустой или выкинуть ошибку)
        print("Google Sign-In для Android еще не реализован")
        return nil
        #else
        guard let clientID = FirebaseApp.app()?.options.clientID else { throw .emailIsAlreadyInUse }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let topViewController = await Utils.getTopViewController() else { return nil }
        return try await googleSignInLogic(topViewController: topViewController)
        #endif
    }
    
    func signInWithApple() async throws(AuthManagerError) -> AuthUserModel? {
        #if !skip
        return try await performIOSAppleSignIn()
        #else
        return try await performAndroidAppleSignIn()
        #endif
    }
    
    private func performAndroidAppleSignIn() async throws(AuthManagerError) -> AuthUserModel? {
        let provider = OAuthProvider(providerID: "apple.com")
        provider.scopes = ["email", "name"]
        
        do {
            let credential = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<AuthCredential, Error>) in
                provider.getCredentialWith(nil) { credential, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else if let credential = credential {
                        continuation.resume(returning: credential)
                    }
                }
            }
            let result = try await Auth.auth().signIn(with: credential)
            
            if result.additionalUserInfo?.isNewUser == true {
                return AuthUserModel(uid: result.user.uid, firstName: result.user.displayName, email: result.user.email, lastName: nil)
            } else {
                return nil
            }
        } catch {
            throw castFirebaseError(error)
        }
    }
    
    private func performIOSAppleSignIn() async throws(AuthManagerError) -> AuthUserModel? {
        #if os(iOS)
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.email, .fullName]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        
        do {
            return try await withCheckedThrowingContinuation { continuation in
                let delegate = AppleSignInDelegate() { result in
                    switch result {
                    case .success(let authResult):
                        if authResult.additionalUserInfo?.isNewUser == true {
                            continuation.resume(returning: AuthUserModel(
                                uid: authResult.user.uid,
                                firstName: authResult.user.displayName,
                                email: authResult.user.email,
                                lastName: nil)
                            )
                        } else {
                            continuation.resume(returning: nil)
                        }
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
                SetRetainer.retain(delegate)
                authorizationController.delegate = delegate
                authorizationController.performRequests()
            }
        } catch {
            throw .appleSignInError(error)
        }
        #endif
    }
    
    #if !skip
    private func googleSignInLogic(topViewController: UIViewController) async throws(AuthManagerError) -> AuthUserModel? {
        do {
            let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: topViewController)
            guard let idToken = result.user.idToken?.tokenString else { throw AuthManagerError.missGoogleIdToken }
            
            let accessToken = result.user.accessToken.tokenString
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            let authResult = try await Auth.auth().signIn(with: credential)
            let changeRequest = authResult.user.createProfileChangeRequest()
            changeRequest.displayName = result.user.profile?.name
            try await changeRequest.commitChanges()
            
            if authResult.additionalUserInfo?.isNewUser == true {
                return AuthUserModel(
                    uid: authResult.user.uid,
                    firstName: authResult.user.displayName,
                    email: authResult.user.email,
                    lastName: nil
                )
            } else {
                return nil
            }
        } catch {
            if let googleError = error as? NSError, googleError.code == GIDSignInError.canceled.rawValue {
                 throw .userCancelledSignIn
             }
             
             if let managerError = error as? AuthManagerError {
                 throw managerError
             }
             throw castFirebaseError(error)
        }
    }
    #endif
    
    private func listenToAuthState() {
        handle = Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            let isLogged = (user != nil)
            self?.signSubject.send(isLogged)
        }
    }
    
    private func castFirebaseError(_ error: Error) -> AuthManagerError {
        guard let errorCode = AuthErrorCode(rawValue: (error as NSError).code) else { return .unknown(error) }
        
        switch errorCode {
        case .emailAlreadyInUse:
            return .emailIsAlreadyInUse
        case .wrongPassword, .userNotFound, .invalidCredential:
            return .userNotFound
        case .invalidEmail:
            return .invalidEmail(error)
        case .networkError, .tooManyRequests:
            return .networkError(error)
        default:
            return .unknown(error)
        }
    }
}
