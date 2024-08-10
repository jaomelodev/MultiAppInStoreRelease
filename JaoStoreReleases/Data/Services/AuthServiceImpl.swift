//
//  LocalAuthServiceImps.swift
//  JaoStoreReleases
//
//  Created by João Melo on 13/07/24.
//

import Foundation
import LocalAuthentication

class AuthServiceImpl: LocalAuthService {
    static var expireAuthDate: Date? = nil
    
    func localAuth() async -> Result<Void, LocalAuthError> {
        if (!Flags.localAuthEnabled) {
            return .success(())
        }
        
        if AuthServiceImpl.expireAuthDate != nil {
            let now = Date()
            
            if now < AuthServiceImpl.expireAuthDate! {
                return .success(())
            }
        }
        
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let reason = "check if its you, to save and read your key"
            
            let authResponse: Result<Void, LocalAuthError> = await withCheckedContinuation { continuation in
                context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authenticationError in
                    if success {
                        AuthServiceImpl.expireAuthDate = Date(timeIntervalSinceNow: 900)
                        continuation.resume(returning: .success(()))
                    } else {
                        continuation.resume(returning: .failure(.authFailed))
                    }
                }
            }
            
            return authResponse
        } else {
            return .failure(.authNotSupported);
        }
    }
}
