//
//  DataItem.swift
//  JaoStoreReleases
//
//  Created by João Melo on 10/07/24.
//

import Foundation

class PrivateKeyInfoData: Identifiable, Codable {
    var id: UUID
    var keyId: String
    var keyContent: Data
    
    init(id: UUID, keyId: String, keyContent: Data) {
        self.id = id
        self.keyId = keyId
        self.keyContent = keyContent
    }
    
    // Convert class instance to JSON String
    func toJSON() -> Data? {
        let encoder = JSONEncoder()
        do {
            return try encoder.encode(self)
        } catch {
            print("Error encoding data: \(error)")
            return nil
        }
    }
    
    // Create class instance from JSON Data
    static func fromJSON(_ jsonData: Data) -> PrivateKeyInfoData? {
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(PrivateKeyInfoData.self, from: jsonData)
        } catch {
            print("Error decoding data: \(error)")
            return nil
        }
    }
}
