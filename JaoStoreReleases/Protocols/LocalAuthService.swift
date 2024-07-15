//
//  LocalAuthService.swift
//  JaoStoreReleases
//
//  Created by João Melo on 13/07/24.
//

import Foundation

protocol LocalAuthService {
    func authenticate() async -> Bool
}
