//
//  RemoveItemKeyChainUseCase.swift
//  JaoStoreReleases
//
//  Created by João Melo on 11/08/24.
//

import Foundation

class RemoveItemKeyChainUseCase: UseCase<String, Void, RemoveItemKeyChainError> {}

class RemoveItemKeyChainUseCaseImpl: RemoveItemKeyChainUseCase {
    let removeItemKeyChainService: RemoveItemKeyChainService
    
    init(removeItemKeyChainService: RemoveItemKeyChainService) {
        self.removeItemKeyChainService = removeItemKeyChainService
    }
    
    override func execute(_ params: String) async -> Result<Void, RemoveItemKeyChainError> {
        return removeItemKeyChainService.removeItemKeyChain(key: params)
    }
}
