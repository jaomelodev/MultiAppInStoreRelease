//
//  KeyChainServiceError.swift
//  JaoStoreReleases
//
//  Created by João Melo on 17/07/24.
//

import Foundation

enum GetItemKeyChainError: Error {
    case keyNotFound
    case unexpectedDataType
    case cannotConvertToType
}
