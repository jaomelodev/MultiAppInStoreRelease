//
//  KeyChainProvider.swift
//  JaoStoreReleases
//
//  Created by João Melo on 12/07/24.
//

import Foundation
import Security

class KeyChainServiceImpl: GetItemKeyChainService, SaveItemKeyChainService, RemoveItemKeyChainService {
    func saveItem(key: String, data: Data) -> Result<Void, SaveItemKeyChainError> {
        let query = [
            kSecClass as String  : kSecClassGenericPassword,
            kSecAttrAccount as String : key,
            kSecValueData as String : data
        ] as [String : Any]
        
        SecItemDelete(query as CFDictionary)
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status != errSecSuccess {
            return .failure(.itemNotSaved)
        }
        
        return .success(())
    }
    
    func getItem(key: String) -> Result<Data, GetItemKeyChainError> {
        let query = [
            kSecClass as String  : kSecClassGenericPassword,
            kSecAttrAccount as String : key,
            kSecReturnData as String : kCFBooleanTrue!,
            kSecMatchLimit as String : kSecMatchLimitOne
        ] as [String : Any]
        
        var dataTypeRef: AnyObject? = nil
        
        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status != errSecSuccess {
            return .failure(.keyNotFound)
        }
        
        guard let data = dataTypeRef as? Data else {
            return .failure(.unexpectedDataType)
        }
        
        return .success(data)
    }
    
    func removeItemKeyChain(key: String) -> Result<Void, RemoveItemKeyChainError> {
        let query = [
            kSecClass as String  : kSecClassGenericPassword,
            kSecAttrAccount as String : key
        ] as [String : Any]
        
        let status = SecItemDelete(query as CFDictionary)
        
        if status != errSecSuccess {
            return .failure(.failedToRemove)
        }
        
        return .success(())
    }
}
