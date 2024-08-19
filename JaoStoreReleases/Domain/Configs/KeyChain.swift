//
//  KeyChain.swift
//  JaoStoreReleases
//
//  Created by João Melo on 11/08/24.
//

import Foundation

struct KeyChain {
    static let privateKeyName: String = ProcessInfo.processInfo.environment["PRIVATE_KEY_NAME"] ?? UUID().uuidString;
}
