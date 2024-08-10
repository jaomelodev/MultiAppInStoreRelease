//
//  SaveItemKeyChainUseCase.swift
//  JaoStoreReleases
//
//  Created by João Melo on 13/07/24.
//

import Foundation

class SaveItemKeyChainUseCase: UseCase<SaveItemKeyChainParams, Void, SaveItemKeyChainError> {}

class SaveItemKeyChainUseCaseImpl: SaveItemKeyChainUseCase {
    let saveItemKeyChainService: SaveItemKeyChainService
    
    init(saveItemKeyChainService: SaveItemKeyChainService) {
        self.saveItemKeyChainService = saveItemKeyChainService
    }
    
    override func execute(_ params: SaveItemKeyChainParams) async -> Result<Void, SaveItemKeyChainError> {
        guard let data = params.keyInfo.toJSON() else {
            return .failure(.couldNotConvertToData)
        }
        
        return saveItemKeyChainService.saveItem(key: params.key, data: data)
    }
}
