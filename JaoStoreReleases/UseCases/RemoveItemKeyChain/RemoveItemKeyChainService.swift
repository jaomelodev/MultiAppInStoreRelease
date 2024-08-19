//
//  RemoveItemKeyChainService.swift
//  JaoStoreReleases
//
//  Created by João Melo on 11/08/24.
//

import Foundation

protocol RemoveItemKeyChainService {
    func removeItemKeyChain(key: String) -> Result<Void, RemoveItemKeyChainError>
}
