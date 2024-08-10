//
//  KeyChainService.swift
//  JaoStoreReleases
//
//  Created by João Melo on 13/07/24.
//

import Foundation

protocol SaveItemKeyChainService {
    func saveItem(key: String, data: Data) -> Result<Void, SaveItemKeyChainError>;
}
