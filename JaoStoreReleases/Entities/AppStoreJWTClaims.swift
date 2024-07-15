//
//  AppStoreJWTClaims.swift
//  JaoStoreReleases
//
//  Created by João Melo on 14/07/24.
//

import Foundation
import SwiftJWT

struct AppStoreJWTClaims: Claims {
    let iss: String
    let aud: String
    let exp: Int
    let iat: Int
}
