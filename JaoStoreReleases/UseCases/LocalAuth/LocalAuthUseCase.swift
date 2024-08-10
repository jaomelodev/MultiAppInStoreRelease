//
//  LocalAuthenticationUseCase.swift
//  JaoStoreReleases
//
//  Created by João Melo on 13/07/24.
//

import Foundation

class LocalAuthUseCase: UseCase<NoParams, Void, LocalAuthError> {}

class LocalAuthUseCaseImpl: LocalAuthUseCase {
    let localAuthService: LocalAuthService
    
    init(localAuthService: LocalAuthService) {
        self.localAuthService = localAuthService
    }
    
    override func execute(_ params: NoParams) async -> Result<Void, LocalAuthError> {
        await localAuthService.localAuth()
    }
}
