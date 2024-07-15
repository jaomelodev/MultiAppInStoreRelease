//
//  SaveItemKeyChainUseCase.swift
//  JaoStoreReleases
//
//  Created by João Melo on 13/07/24.
//

import Foundation

class SaveItemKeyChainUseCase: UseCase {
    typealias ParamsUseCase = SetItemKeyChainParams
    typealias ResultUseCase = OSStatus?
    
    let keyChainService: KeyChainService
    
    init(keyChainService: KeyChainService) {
        self.keyChainService = keyChainService
    }
    
    func execute(_ params: ParamsUseCase) async throws -> ResultUseCase {
        guard let data = params.keyInfo.toJSON() else {
            return nil
        }
        
        return keyChainService.saveItem(key: params.key, data: data)
    }
}
