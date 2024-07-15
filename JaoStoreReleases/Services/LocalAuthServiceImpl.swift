//
//  LocalAuthServiceImps.swift
//  JaoStoreReleases
//
//  Created by João Melo on 13/07/24.
//

import Foundation
import LocalAuthentication

class LocalAuthServiceImpl: LocalAuthService {
    func authenticate() async -> Bool {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let reason = "check if its you, to save and read your key"
            
            let authResponse: Bool = await withCheckedContinuation { continuation in
                context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authenticationError in
                    if success {
                        continuation.resume(returning: true)
                    } else {
                        continuation.resume(returning: false)
                    }
                }
            }
            
            return authResponse
        } else {
            return false;
        }
    }
}
