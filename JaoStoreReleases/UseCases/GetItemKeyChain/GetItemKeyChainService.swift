//
//  GetItemKeyChainService.swift
//  JaoStoreReleases
//
//  Created by João Melo on 16/07/24.
//

import Foundation

protocol GetItemKeyChainService {
    func getItem(key: String) -> Result<Data, GetItemKeyChainError>;
}
