//
//  GetItemKeyChainUseCase.swift
//  JaoStoreReleases
//
//  Created by João Melo on 13/07/24.
//

import Foundation

class GetItemKeyChainUseCase: UseCase {
    typealias ParamsUseCase = String
    typealias ResultUseCase = PrivateKeyInfoData?
    
    let keyChainService: KeyChainService
    
    init(keyChainService: KeyChainService) {
        self.keyChainService = keyChainService
    }
    
    func execute(_ params: ParamsUseCase) async throws -> ResultUseCase {
        guard let resultFromKeyChain = keyChainService.loadItem(key: params) else {
            return nil
        }
        
        return PrivateKeyInfoData.fromJSON(resultFromKeyChain)
    }
}
