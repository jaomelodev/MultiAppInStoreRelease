//
//  KeyChainService.swift
//  JaoStoreReleases
//
//  Created by João Melo on 13/07/24.
//

import Foundation

protocol KeyChainService {
    func saveItem(key: String, data: Data) -> OSStatus;
    func loadItem(key: String) -> Data?;
}
