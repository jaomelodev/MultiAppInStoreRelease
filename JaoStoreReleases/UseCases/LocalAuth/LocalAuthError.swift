//
//  AuthServiceErrors.swift
//  JaoStoreReleases
//
//  Created by João Melo on 17/07/24.
//

import Foundation

enum LocalAuthError: Error {
    case authNotSupported
    case authFailed
}
