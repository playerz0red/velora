//
//  File.swift
//  velora
//
//  Created by Pavel Playerz0redd on 8.07.26.
//

import Foundation
import SkipFirebaseAuth
import UIKit

#if !skip
import AuthenticationServices
#endif


final class AppleSignInDelegate: NSObject, ASAuthorizationControllerDelegate {
    let completion: (Result<AuthDataResult, Error>) -> Void
    
    init(completion: @escaping (Result<AuthDataResult, Error>) -> Void) {
        self.completion = completion
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let appleIDToken = appleIDCredential.identityToken,
              let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            completion(.failure(NSError(domain: "Auth", code: -1, userInfo: [NSLocalizedDescriptionKey: "Не удалось получить токен Apple"])))
            SetRetainer.release(self)
            return
        }
        
        let credential = OAuthProvider.credential(providerID: .apple, idToken: idTokenString)
        
        Task {
            do {
                let result = try await Auth.auth().signIn(with: credential)
                completion(.success((result)))
            } catch {
                completion(.failure(error))
            }
            SetRetainer.release(self)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        completion(.failure(error))
        SetRetainer.release(self)
    }
}

final class SetRetainer {
    nonisolated(unsafe) static var retainedObjects = Set<NSObject>()
    static func retain(_ obj: NSObject) { retainedObjects.insert(obj) }
    static func release(_ obj: NSObject) { retainedObjects.remove(obj) }
}

