//
//  LocalAuthenticationUseCase.swift
//  JaoStoreReleases
//
//  Created by João Melo on 13/07/24.
//

import Foundation

class LocalAuthenticationUseCase: UseCase {
    typealias ParamsUseCase = NoParams
    typealias ResultUseCase = Bool
    
    let localAuthenticationService: LocalAuthService
    
    init(localAuthenticationService: LocalAuthService) {
        self.localAuthenticationService = localAuthenticationService
    }
    
    func execute(_ params: ParamsUseCase) async throws -> ResultUseCase {
        await localAuthenticationService.authenticate()
    }
}
