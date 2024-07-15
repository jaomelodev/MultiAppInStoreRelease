//
//  KeyChainProvider.swift
//  JaoStoreReleases
//
//  Created by João Melo on 12/07/24.
//

import Foundation
import Security

class KeyChainServiceImpl: KeyChainService {
    func saveItem(key: String, data: Data) -> OSStatus {
        let query = [
            kSecClass as String  : kSecClassGenericPassword,
            kSecAttrAccount as String : key,
            kSecValueData as String : data
        ] as [String : Any]
        
        SecItemDelete(query as CFDictionary)
        
        return SecItemAdd(query as CFDictionary, nil)
    }
    
    func loadItem(key: String) -> Data? {
        let query = [
            kSecClass as String  : kSecClassGenericPassword,
            kSecAttrAccount as String : key,
            kSecReturnData as String : kCFBooleanTrue!,
            kSecMatchLimit as String : kSecMatchLimitOne
        ] as [String : Any]
        
        var dataTypeRef: AnyObject? = nil
        
        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess {
            if let data = dataTypeRef as? Data {                
                return data
            } else {
                // Handle unexpected data type
                print("Unexpected data type")
                return nil
            }
        } else {
            // Handle the error (e.g., item not found)
            print("Error: \(status)")
            return nil
        }
    }
}
