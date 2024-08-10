//
//  GetItemKeyChainUseCase.swift
//  JaoStoreReleases
//
//  Created by João Melo on 13/07/24.
//

import Foundation

class GetItemKeyChainUseCase: UseCase<String, PrivateKeyInfoData, GetItemKeyChainError> {}

class GetItemKeyChainUseCaseImpl: GetItemKeyChainUseCase {
    let getItemKeyChainService: GetItemKeyChainService
    
    init(getItemKeyChainService: GetItemKeyChainService) {
        self.getItemKeyChainService = getItemKeyChainService
    }
    
    override func execute(_ params: String) async -> Result<PrivateKeyInfoData, GetItemKeyChainError> {
        let result = getItemKeyChainService.getItem(key: params)
        
        if case .failure(let failure) = result {
            return .failure(failure)
        }
        
        guard let data = try? result.get() else {
            return .failure(.cannotConvertToType)
        }
        
        guard let privateKeyInfoData = PrivateKeyInfoData.fromJSON(data) else {
            return .failure(.cannotConvertToType)
        }
        
        return .success(privateKeyInfoData)
    }
}
